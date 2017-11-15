cask 'intellij-idea-newest' do
  full_name = 'IntelliJ IDEA 2017.3 EAP.app'

  version '2017.3-173.3622.25'
  sha256 '552acc15a34d14193f1f43ada3a149e6b44853638e22585b6714a7a696af611e'

  url "https://download.jetbrains.com/idea/ideaIU-#{version.sub(%r{.*?-}, '')}.dmg"
  appcast 'https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=eap',
          checkpoint: '358bf77aae8dd9e7a889df3924545d6f77f48529a59060599ad339f8a92cdc00'
  name 'IntelliJ IDEA EAP'
  homepage 'https://www.jetbrains.com/idea/nextversion'

  auto_updates true

  app full_name
  binary 'Contents/MacOS/idea'

  postflight do
    open("#{staged_path}/#{full_name}/Contents/bin/idea.properties", 'a') do |file|
      file.puts 'idea.case.sensitive.fs=true'
    end

    system '/usr/bin/sed', '-i', '.bak', 's/-Xmx.*/-Xmx2048m/', "#{staged_path}/#{full_name}/Contents/bin/idea.vmoptions"
  end

  uninstall delete: '/usr/local/bin/idea'

  zap delete: [
                "~/Library/Caches/IntelliJIdea#{version.major_minor}",
                "~/Library/Logs/IntelliJIdea#{version.major_minor}",
                '~/Library/Saved Application State/com.jetbrains.intellij.savedState',
              ],
      trash:  [
                "~/Library/Application Support/IntelliJIdea#{version.major_minor}",
                "~/Library/Preferences/IntelliJIdea#{version.major_minor}",
                '~/Library/Preferences/com.jetbrains.intellij.plist',
              ]
end

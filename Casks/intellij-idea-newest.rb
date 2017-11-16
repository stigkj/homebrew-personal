cask 'intellij-idea-newest' do
  full_name = 'IntelliJ IDEA 2017.3 EAP.app'
  full_path = "/Applications/#{full_name}"

  version '2017.3-173.3622.25'
  sha256 '2a11c426f16cb752c96d6638c8ee9492217e84420f57f7b2564498bfc435167c'

  url "https://download.jetbrains.com/idea/ideaIU-#{version.sub(%r{.*?-}, '')}.dmg"
  appcast 'https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=eap',
          checkpoint: '358bf77aae8dd9e7a889df3924545d6f77f48529a59060599ad339f8a92cdc00'
  name 'IntelliJ IDEA EAP'
  homepage 'https://www.jetbrains.com/idea/nextversion'

  auto_updates true

  app full_name

  postflight do
    open("#{full_path}/Contents/bin/idea.properties", 'a') do |file|
      file.puts 'idea.case.sensitive.fs=true'
    end

    system '/usr/bin/sed', '-i', '.bak', 's/-Xmx.*/-Xmx2048m/', "#{full_path}/Contents/bin/idea.vmoptions"
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

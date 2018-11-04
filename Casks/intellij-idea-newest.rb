cask 'intellij-idea-newest' do
  version '2018.3,183.4139.22'
  sha256 '677f2be07b4402c10e38cd2d2f37a1d052963babf5e96ed3acda74f10e91d311'

  url "https://download.jetbrains.com/idea/ideaIU-#{version.after_comma}.dmg"
  appcast 'https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=eap',
          checkpoint: '358bf77aae8dd9e7a889df3924545d6f77f48529a59060599ad339f8a92cdc00'
  name 'IntelliJ IDEA Ultimate'
  homepage 'https://www.jetbrains.com/idea/nextversion'

  auto_updates true

  app "IntelliJ IDEA #{version.major_minor} EAP.app"
  #app "IntelliJ IDEA.app"

  postflight do
    full_path = "#{ENV['HOME']}/Library/Preferences/IntelliJIdea#{version.major_minor}"
    system('mkdir', '-p', full_path)

    open("#{full_path}/idea.properties", 'a') do |file|
      file.puts 'idea.case.sensitive.fs=true'
    end

    system '/usr/bin/sed', '-i', '.bak', 's/-Xmx.*/-Xmx2048m/', "#{full_path}/idea.vmoptions"
    system '/usr/bin/sed', '-i', '.bak', 's/-Xms.*/-Xms1024m/', "#{full_path}/idea.vmoptions"
  end

  uninstall delete: '/usr/local/bin/idea'

  uninstall_postflight do
    ENV['PATH']
        .split(File::PATH_SEPARATOR)
	.map { |path| File.join(path, 'idea') }
	.each { |path| 
	    File.delete(path) if File.exist?(path) && 
                                 File.readlines(path)
		                     .grep(%r{# see com.intellij.idea.SocketLock for the server side of this interface})
		                     .any? 
        }
  end

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

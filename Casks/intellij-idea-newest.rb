cask 'intellij-idea-newest' do
  version '2024.2,242.14146.16'
  sha256 '70897070443a1abe30aafa58b726e98030185cb632d1583fa86f3e1e3daa0a23'

  url "https://download.jetbrains.com/idea/ideaIU-#{version.after_comma}-aarch64.dmg"
  #url "https://download.jetbrains.com/idea/ideaIU-#{version.before_comma}-aarch64.dmg"
  name 'IntelliJ IDEA Ultimate'
  homepage 'https://www.jetbrains.com/idea/nextversion'

  auto_updates true
  
  app "IntelliJ IDEA #{version.major_minor} EAP.app"
  #app "IntelliJ IDEA.app"

  postflight do
    full_path = "#{ENV['HOME']}/Library/Application Support/JetBrains/IntelliJIdea#{version.major_minor}"
    system('mkdir', '-p', full_path)

    open("#{full_path}/idea.properties", 'a') do |file|
      file.puts 'idea.case.sensitive.fs=true'
    end
  end

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

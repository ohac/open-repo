# -*- coding: utf-8 -*-

module OpenRepo

  class Mercurial
    attr_accessor :host, :user, :protocol
    def initialize(options = {})
      self.host = options[:host]
      self.user = options[:user] || ENV['USER']
      self.protocol = options[:protocol] || :ssh
    end

    def list(dir = '.')
      case protocol
      when :ssh
        r = exec("ssh #{user}@#{host} find #{dir} -type d -name .hg")
        repos = r.split.map{|repo| repo.chomp('/.hg')}
        patches_repos = repos.select{|repo| repo.index('.hg/patches')}
        repos -= patches_repos
        patches_repos = patches_repos.map{|r| r.chomp('/.hg/patches')}
        repos -= patches_repos
        repos = repos.map{|r| [r, false]}
        repos += patches_repos.map{|r| [r, true]}
        repos.map{|repo| [repo[0].gsub(/\A#{dir}./, ''), repo[1]]}
      else
        raise
      end
    end

    def clone(r, dest)
      case protocol
      when :ssh
        exec("hg #{r[1] ? 'q' : ''}clone ssh://#{user}@#{host}/#{r[0]} #{dest}")
      else
        raise
      end
    end

    def exec(cmd)
      `#{cmd}`
    end

  end

end

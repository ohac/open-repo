require 'helper'

module OpenRepo
  class Mercurial
    def exec(cmd)
      ["./a/b", "./b/c/.hg/patches"].join("\n")
    end
  end
end

class TestOpenRepo < Test::Unit::TestCase

  should "" do
    hg = OpenRepo::Mercurial.new(:user => 'taro', :host => 'example.com')
    assert_equal hg.user, 'taro'
    assert_equal hg.host, 'example.com'
    l = hg.list
    assert_equal l, [['a/b', false], ['b/c', true]]
    withoutpatch = l.find{|r|!r[1]}
    withpatch = l.find{|r|r[1]}
    hg.clone(withoutpatch, 'withoutpatch')
    hg.clone(withpatch, 'withpatch')
  end

end

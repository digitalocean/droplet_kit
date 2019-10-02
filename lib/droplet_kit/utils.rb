module DropletKit
  module Utils
    def self.camelize(term)
      string = term.to_s
      string.sub!(/^[a-z\d]*/, &:capitalize)
      string.gsub!(%r{(?:_|(/))([a-z\d]*)}i) { $2.capitalize }
      string.gsub!('/'.freeze, '::'.freeze)
      string
    end

    def self.underscore(term)
      return term unless /[A-Z-]|::/ =~ term

      word = term.to_s.gsub('::'.freeze, '/'.freeze)
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
      word.tr!('-'.freeze, '_'.freeze)
      word.downcase!
      word
    end

    def self.transform_keys(hash, &block)
      return hash.transform_keys(&block) if hash.respond_to?(:transform_keys)
      return to_enum(__caller__) unless block_given?

      {}.tap do |result|
        hash.each do |key, value|
          result[block.call(key)] = value
        end
      end
    end
  end
end

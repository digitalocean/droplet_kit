# frozen_string_literal: true

module DropletKit
  module Utils
    def self.camelize(term)
      string = term.to_s
      string.sub!(/^[a-z\d]*/, &:capitalize)
      string.gsub!(%r{(?:_|(/))([a-z\d]*)}i) { Regexp.last_match(2).capitalize }
      string.gsub!('/', '::')
      string
    end

    def self.underscore(term)
      return term unless /[A-Z-]|::/.match?(term)

      word = term.to_s.gsub('::', '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase!
      word
    end

    def self.transform_keys(hash, &block)
      return hash.transform_keys(&block) if hash.respond_to?(:transform_keys)
      return to_enum(__caller__) unless block

      {}.tap do |result|
        hash.each do |key, value|
          result[yield(key)] = value
        end
      end
    end
  end
end

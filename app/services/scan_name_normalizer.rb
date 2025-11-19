class ScanNameNormalizer
  def self.normalize(name)
    return "" if name.blank?

    name = name.gsub("CODE", "")
               .gsub(".html", "")
               .strip

    name = I18n.transliterate(name)

    name.downcase
        .gsub(/[_\s]+/, "-")
        .gsub(/-+/, "-")
        .strip
  end
end

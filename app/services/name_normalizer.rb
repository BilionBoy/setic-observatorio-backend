class NameNormalizer
  def self.normalize(name)
    return "" if name.blank?

    name = name.to_s.downcase

    # remove prefixos frequentes
    name = name.gsub(/(was_|code_|scan_)/, "")

    # remove .html, .htm etc
    name = name.gsub(/\.html?/, "")

    # remove acentos
    name = I18n.transliterate(name)

    # remove caracteres não alfanuméricos
    name = name.gsub(/[^a-z0-9]/, "")

    name
  end
end

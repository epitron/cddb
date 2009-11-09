module NodesHelper
  def highlight_words(s, words)
    expr = words.map { |w| Regexp.escape(w) }.join('|')
    s.gsub(/(#{expr})/i, '<span class="highlight">\\1</span>')
  end
end

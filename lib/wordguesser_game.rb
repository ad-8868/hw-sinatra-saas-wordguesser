class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word.to_s
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    guess_text = letter.to_s
    raise ArgumentError, 'Guess must be a single letter' if guess_text.empty? || !guess_text.match?(/\A[a-zA-Z]\z/)

    normalized = guess_text.downcase
    return false if @guesses.downcase.include?(normalized) || @wrong_guesses.downcase.include?(normalized)

    if @word.downcase.include?(normalized)
      @guesses += normalized
    else
      @wrong_guesses += normalized
    end

    true
  end

  def word_with_guesses
    @word.chars.map do |char|
      @guesses.downcase.include?(char.downcase) ? char : '-'
    end.join
  end

  def check_win_or_lose
    return :win if @word.to_s != '' && @word.downcase.chars.uniq.all? { |char| @guesses.downcase.include?(char) }
    return :lose if @wrong_guesses.length >= 7

    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      return http.post(uri, "").body
    end
  end
end

#!/usr/bin/ruby
require 'rubygems'
require 'wordnik'

Wordnik.configure do |config|
	config.api_key = 'ebecc429703e05401e00405c97f0d614b2f8c8698985909ca'
	config.logger = Logger.new('/dev/null')
end

class DictApp
   @@hintFlag = 0
   def initialize ()
   end
# DEFINITION OF WORD
   def definitions(word)
              definitions= Wordnik.word.get_definitions(word)
               if definitions.length == 0 then
                  puts " #{word} word is not found in the dictionary"
                   self.wrong_word(word)
                  else 
               puts "Definitions of the word : #{word} \n"
 	   	 Wordnik.word.get_definitions(word).each do |d|
                   puts d['text']  #display some similar word
   	        end
              end
   end
# SYNONYMS OF WORD
   def synonyms(word)
           # Wordnik.word.synonyms(word)
           syn = Wordnik.word.get_related(word, :type => 'synonym')
           if syn.blank? || syn.length == 0 then
              puts " #{word} word is not found in the dictionary"     
              self.wrong_word(word)
           else 
           puts "Synonyms of word: #{word} is \n" 
           puts "#{syn.at(0)['words']
}"
        end
   end
# ANTONYMS OF THE WORD
   def antonyms(word)
          ant = Wordnik.word.get_related(word, :type => 'antonym')
          if ant.blank? || ant.length == 0 then
              puts " #{word} word is not found in the dictionary" 
              self.wrong_word(word)
 	  else 
              	 puts "Antonyms of word: #{word} is \n"                  
                 puts" #{ant.at(0)['words']}"
          end
   end
# EXAMPLE OF THE WORD
   def examples(word)
          examples = Wordnik.word.get_examples( word, :includeDuplicates => 'false', :useCanonical => 'false')['examples'] 
     		
          if examples.length == 0 then
              puts " #{word} word is not found in the dictionary"
              self.wrong_word(word)
          else
                 puts "Examples of word: #{word} is \n"
                 examples.each do |a|         
                         puts a['text'] end
          end
   end
 # FULL DICTIONAY
   def full_dics(word)
              self.definitions(word)
              puts "\n"
              self.synonyms(word)
 	      puts "\n"
              self.antonyms(word)
              puts "\n"
              self.examples(word)
   end
# 
   def day_full_dics()
    word= Wordnik.words.get_word_of_the_day(:date => Time.now)['word']    
    self.full_dics(word)
   end

   def word_game()
      word = Wordnik.words.get_random_word(:hasDictionaryDef => 'true')['word']
      
      #if @@hintFlag == 1 then
         puts "Word is: #{word}\n\n"
      #end
	      puts " Definition of word: #{self.definitions(word)}"
	      puts " \n\nSynonyms of the word:  #{self.synonyms(word)}"
	      puts "\n\n Antonyms of the word: #{self.antonyms(word)}"
      if @@hintFlag == 0 then
      	puts " \n\nPlease Enter the correct word with the help of above details of word"
      else
         @@hintFlag = 0
         self.word_game()
      end
      user_word = $stdin.gets.chomp
      puts "You Entered: #{user_word}"
      if user_word == word || word == self.synonyms(user_word)  then
       puts "You have entered correct word !! "
       puts"#{self.full_dics(word)}"
      else
       puts "The word you have entered is INCORRECT :( \n Please Try Again\n HINT:"
      @@hintFlag = 1
       self.word_game()
       end
  end

  def wrong_word(word)
     puts "here is some similar words of #{word}"
     self.display_similar_word(word) 
  end

  def display_similar_word(word)
    Wordnik.word.get_related_words('cat', :useCanonical => 'false', :relationshipTypes => 'equivalent')
  end
end

 dictApp = DictApp.new()

case ARGV[0]
   when "def" then dictApp.definitions(ARGV[1])
   when "syn" then dictApp.synonyms(ARGV[1])
   when "ant" then dictApp.antonyms(ARGV[1])
   when "ex" then dictApp.examples(ARGV[1])
   when "dict" then dictApp.full_dics(ARGV[1])
   when "day_dict" then dictApp.day_full_dics()
   when "play" then dictApp.word_game()
   else  puts "Error: Aurgument supplied is not valid:"
end


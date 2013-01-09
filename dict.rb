#!/usr/bin/ruby
require 'rubygems'
require 'wordnik'

Wordnik.configure do |config|
	config.api_key = 'ebecc429703e05401e00405c97f0d614b2f8c8698985909ca'
	config.logger = Logger.new('/dev/null')
end
	
class DictApp
   @@game_flag = 0
   @@wrong_word = 0
   def initialize ()
   end
# DEFINITION OF WORD
   def definitions(word)
              definitions= Wordnik.word.get_definitions(word)
               if definitions.blank? || definitions.length == 0 then
                     if(@@game_flag == 0) then
                       puts " #{word} : word defintion is not found in the dictionary"            
                   else
                     @@wrong_word = 1        
                   end
               else 
                  if(@@game_flag == 1) then
	                  puts "Definition of the word for Word Game: \n"
        	          if(definitions.length > 0) then
                          	 rand_num = Random.rand(0...definitions.length)
                	  	 puts definitions.at(rand_num)['text']
        		  else
                                  puts definitions.at(0)['text']	                
                          end
                 else
	        	  puts "Definitions of the word : #{word} \n"
 	   	   definitions.each do |d|
                   puts d['text']  
                      end
                 end
              end
   end
# SYNONYMS OF WORD
   def synonyms(word)
           # Wordnik.word.synonyms(word)
           syn = Wordnik.word.get_related(word, :type => 'synonym')
           if syn.blank? || syn.length == 0 then
              if(@@game_flag == 0) then
                puts "Synonyms is not found in the dictionary for word: #{word}"     
              else
                 @@wrong_word = 1 
              end
           else
           if(@@game_flag == 1) then
                          puts "synonym of the word for Word Game : \n"
			 if(syn.at(0)['words'].length > 0) then
                        	  rand_num = Random.rand(0...syn.at(0)['words'].length)
                          	  puts "#{syn.at(0)['words'].at(rand_num)}"
                         else
                                  puts "#{syn.at(0)['words'].at(0)}"
                           end
                 else
 
	           puts "Synonyms of word: #{word} is \n" 
        	   puts "#{syn.at(0)['words']}"
           end
        end
   end
# ANTONYMS OF THE WORD
   def antonyms(word)
          ant = Wordnik.word.get_related(word, :type => 'antonym')
          if ant.blank? || ant.length == 0 then
             if(@@game_flag == 0) then
                puts " Antonyms is not found in the dictionary for word: #{word}"            
              else
                 @@wrong_word = 1
              end
 	   else 
              if(@@game_flag == 1) then
                          puts "Antonyms of the word for Word Game: \n"
                        if(ant.at(0)['words'].length > 0) then
                          rand_num = Random.rand(1...ant.at(0)['words'].length)
                          puts "#{ant.at(0)['words'].at(rand_num)}"
                        else
                          puts "#{ant.at(0)['words'].at(0)}"
                         end 
                 else 
	                puts "Antonyms of word: #{word} is \n"                  
        	        puts" #{ant.at(0)['words']}"
                end
             end
    end
# EXAMPLE OF THE WORD
   def examples(word)
          examples = Wordnik.word.get_examples( word, :includeDuplicates => 'false', :useCanonical => 'false')['examples'] 
     		
          if examples.blank? || examples.length == 0 then
              puts " #{word} word exmople is not found in the dictionary"
              self.wrong_word(word)
          else
                 puts "Examples of word: #{word} is \n"
                 examples.each do |a|         
                         puts a['text'] end
          end
   end
 # FULL DICTIONAY
   def full_dics(word)
    puts "Here is the full dictionary of the word: #{word}"
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
    	puts "word of the day is: #{word}"
    self.full_dics(word)
   end

   def word_game()
      word = Wordnik.words.get_random_word(:hasDictionaryDef => 'true')['word']
      puts "\n\n**************Welcome to the Word Game **************\n"
      puts "**Here is somthing  about the word, You need to Enter correct word ***\n"
      @@game_flag = 1
          while 1
              num = Random.rand(1...4)
               case num        
	 	   when 1 then  self.definitions(word)
                   when 2 then  self.synonyms(word)
                   when 3 then  self.antonyms(word)
              end
             if(@@wrong_word == 1)
                @@wrong_word = 0
                 next
             else
               break
          end
        end
        while 1
      	puts " \n\nPlease Enter the correct word "
      	user_word = $stdin.gets.chomp
	      puts "You Entered: #{user_word}"
	      if user_word == word  then
		       puts " CONGRATULATIONS !!!! You have entered correct word !! "
                       @@game_flag = 0
	       	       puts "#{self.full_dics(word)}"
                       try_again_flag = 0                 
	      else
       puts "OOPS!!!!! The word you have entered is INCORRECT :( "
       puts " Press: 1 -> To Try Again \n Press: 2 -> To Take Hint \n Press: 3 -> To QUIT the Game \n"
       option = $stdin.gets.chomp
       try_again_flag = 0
       case option
           when "1" then try_again_flag = 1 
           when "2" then begin puts "HINT :"
                         try_again_flag = 1
                         self.display_hint(word)
                         end
           when "3" then begin puts "Word is : #{word} "
                       @@game_flag = 0
                       self.full_dics(word)
                       end
           else puts "Option you entered is not correct"
         end            
  	end
          if try_again_flag == 1 then
                  next
         else
                  break
         end
       end
    		puts "\n\n*********THANK YOU FOR PLAYING WORD GAME**********\n"
      @@game_flag = 0
  end
  def wrong_word(word)
     puts "here is some similar words of #{word}"
     self.display_similar_word(word) 
  end

  def display_similar_word(word)
    Wordnik.word.get_related_words('cat', :useCanonical => 'false', :relationshipTypes => 'equivalent')
  end
  
  def display_hint(word)
   num = Random.rand(1...4)
               case num
                   when 1 then  self.definitions(word)
                   when 2 then  self.synonyms(word)
                   when 3 then  self.antonyms(word)
              end

  end
 
end

 dictApp = DictApp.new()
if ARGV.blank? then
dictApp.day_full_dics()
else
case ARGV[0]
   when "def" then dictApp.definitions(ARGV[1])
   when "syn" then dictApp.synonyms(ARGV[1])
   when "ant" then dictApp.antonyms(ARGV[1])
   when "ex" then dictApp.examples(ARGV[1])
   when "dict" then dictApp.full_dics(ARGV[1])
   #when "day_dict" then dictApp.day_full_dics()
   when "play" then dictApp.word_game()
   else  puts "Error: Aurgument supplied is not valid:"
end
end

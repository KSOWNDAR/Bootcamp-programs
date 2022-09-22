def find_anagram_words(word_list,anagram_words)
    for word in word_list
        sorted_word = word.chars.sort.join 
        word_array = [word]
        anagram_words[sorted_word] += word_array
    end
    p anagram_words.values
end

def main
    puts "Enter the words"
    words = gets.chomp()
    anagram_words_list = []
    anagram_words = Hash.new([])
    word_list = words.split(' ')
    if words.length == 0 
       p anagram_words_list.append([""])
       exit 
    end
    find_anagram_words(word_list,anagram_words)
end
main 






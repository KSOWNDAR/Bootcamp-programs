def calculate_total_amount()
    available_coins_and_notes = [1,1,2,2,5,5,10,10,20,50,100,200,500,2000]
    total_amount = money_value = 0
    for amount in $cash_box.values
       total_amount += available_coins_and_notes[money_value] * amount
       money_value += 1
    end
    total_amount 
end

def create_order(cost_price_list,balance_amount_list,given_amount_list,order_count,balance_cost)
    while 1 
        puts "Hi Sir.Welcome to Super Market."
        puts "Do you want to purchase? Press Y for YES and N for NO"
        purchase = gets().chomp 
        duplicate_cash_box = $cash_box.clone 
        if purchase.casecmp?("N")
            puts duplicate_cash_box
            return 
        end
        order_count = order_count + 1
        puts "Enter cost price:"
        cost_price_list[order_count-1] = gets.chomp.to_i
        puts "Enter the amount you are giving"
        given_amount_list[order_count-1] = gets.chomp.to_i  
        validate_order(cost_price_list,order_count,given_amount_list,balance_amount_list,balance_cost,duplicate_cash_box)
        balance_amount_list[order_count-1] = given_amount_list[order_count-1] - cost_price_list[order_count-1]
        cash_box_credit(cost_price_list,order_count,given_amount_list,balance_amount_list,balance_cost,duplicate_cash_box)
    end
end

def validate_order(cost_price_list,order_count,given_amount_list,balance_amount_list,balance_cost,duplicate_cash_box)
    if (calculate_total_amount() == 0 && (cost_price_list[order_count - 1] != given_amount_list[order_count - 1]))
        cost_price_list[cost_price_list.length - 1] = 0
        given_amount_list.delete_at[given_amount_list.length - 1] = 0
        puts "Sorry I not have balance to give .Please give a valid amount or purchase other things"
        $cash_box = duplicate_cash_box.clone 
        puts $cash_box
        create_order(cost_price_list,balance_amount_list,given_amount_list,order_count,balance_cost,duplicate_cash_box)
    end
    if given_amount_list[order_count-1] == 0 
        cost_price_list[cost_price_list.length-1] = 0
        given_amount_list[given_amount_list.length-1] = 0
        create_order(cost_price_list,balance_amount_list,given_amount_list,order_count,balance_cost)
    elsif cost_price_list[order_count-1] == 0 and given_amount_list[order_count-1] > 0
        puts "Please take your money or purchase items"
        create_order(cost_price_list,balance_amount_list,given_amount_list,order_count,balance_cost)
    end    
    while given_amount_list[order_count-1] < cost_price_list[order_count-1]
        puts "Please give your cash correctly"
        given_amount_list[order_count-1] = gets.chomp.to_i
    end
end

def cash_box_credit(cost_price_list,order_count,given_amount_list,balance_amount_list,balance_cost,duplicate_cash_box)
    puts "Enter the denominations:"
    total_money = 0
    cash_collection = []
    cashes = [2000,500,200,100,50,20,10,5,2,1]
    while(total_money < given_amount_list[order_count-1])
        amount_given = gets.chomp 
        while !((cashes.include?(amount_given.to_i)&&(amount_given.to_i).to_s == amount_given) || amount_given === '5c' || amount_given === '10c')
            puts "Give a valid money"
            amount_given = gets.chomp
        end
        cash_collection.append(amount_given.to_s)
        case amount_given
        when '1c' then total_money += 1
        when '2c' then total_money += 2    
        when '5c' then total_money += 5
        when '10c' then total_money += 10
        else  total_money += amount_given.to_i 
        end    
    end
    cash_collection.each{|cash| $cash_box[cash] += 1}
    cash_box_debit(balance_cost,balance_amount_list,order_count,cost_price_list,given_amount_list,duplicate_cash_box)
end

def cash_box_debit(balance_cost,balance_amount_list,order_count,cost_price_list,given_amount_list,duplicate_cash_box)
    cashes = [2000,500,200,100,50,20,10,5,2,1]
    balance_cost = balance_amount_list[order_count-1]
    while balance_cost > 0
        value_of_note = 0
        customer_purchased,chocolate_given = true,false
        money,value_of_note = calculate_amount_to_give(value_of_note,cashes,balance_cost) 
        if(value_of_note == cashes.length && balance_cost <= 5)
            chocolate_for_balance(balance_amount_list,order_count,balance_cost,chocolate_given,cost_price_list)
            chocolate_given = true
            break
        elsif(value_of_note == cashes.length)
            customer_purchased = false
            balance_insufficient(cost_price_list,given_amount_list,balance_amount_list,order_count,duplicate_cash_box)
            break
        else
            money = (cashes[value_of_note]).to_s 
            money = check_for_coin_availability(money)
            if($cash_box[money] != 0)
               balance_cost -= cashes[value_of_note]
               $cash_box[money] -= 1 
            end
        end
    end    
    if customer_purchased
       if (!chocolate_given) then puts "The balance amount is #{balance_amount_list[order_count-1]}" end
       puts "Thank you for purchasing."
    end
    final_amount = calculate_total_amount()
    validate_cash_box(final_amount,cost_price_list)       
end 

def calculate_amount_to_give(value_of_note,cashes,balance_cost)
    while((value_of_note < cashes.length) && ((balance_cost/cashes[value_of_note]).abs <= 0))
        value_of_note += 1
    end 
    money = (cashes[value_of_note]).to_s
    while((value_of_note < cashes.length) && ($cash_box[money]<=0))
        if (is_coin(money))
            money += "c"
            if $cash_box[money] == 0 
              money = money[0..-2]
            else
              break 
            end
        end 
        value_of_note += 1
        money = (cashes[value_of_note]).to_s
    end
    return money,value_of_note 
end

def balance_insufficient(cost_price_list,given_amount_list,balance_amount_list,order_count,duplicate_cash_box)
    cost_price_list[order_count - 1] = 0
    given_amount_list[order_count - 1] = 0
    balance_amount_list[order_count - 1] = 0
    puts "Sorry I have not a enough balance to give"
    $cash_box = duplicate_cash_box.clone 
    puts($cash_box)
end

def chocolate_for_balance(balance_amount_list,order_count,balance_cost,chocolate_given,cost_price_list)
    if (balance_amount_list[order_count - 1] - balance_cost) !=0 
        puts "Take the amount #{(balance_amount_list[order_count - 1] - balance_cost)}"
    end
    puts "No change...Please take a chocolate for Rs.#{balance_cost}"
    chocolate_given = true 
    cost_price_list[order_count - 1] += balance_cost 
    balance_amount_list[order_count - 1] = balance_cost
end

def check_for_coin_availability(money)
    if (is_coin(money))
        money += "c"
        if $cash_box[money] == 0 
         money = money[0..-2]
        end
    end 
    money
end

def is_coin(money)
    if((money.eql?("10")) || (money.eql?("5")) || (money.eql?("2")) || (money.eql?("1")))
        return true
    else
        return false
    end
end

def validate_cash_box(final_amount,cost_price_list)
    puts "Validating cash box..."
    if (final_amount - $initial_amount) == (cost_price_list.sum)
        puts "Cash box validated.It is correct.Continue your business"
    else
        puts "Cash box validated.It is incorrect.Stop and Check where you missed"
    end
end

def open_shop
    cost_price_list = []
    given_amount_list = []
    balance_amount_list = []
    order_count = balance_cost = 0
    $initial_amount = calculate_total_amount()
    order_details = [cost_price_list,given_amount_list,balance_amount_list]
    create_order(cost_price_list,balance_amount_list,given_amount_list,order_count,balance_cost)

    puts "Customer_id    Purchased cost    Given amount    Balance amount"
    for order_number in 1..cost_price_list.length
       if cost_price_list[order_number-1] != 0 
         puts "    #{order_number}              #{cost_price_list[order_number-1]}               #{given_amount_list[order_number-1]}              #{(given_amount_list[order_number-1]) - (cost_price_list[order_number-1])}" 
       end
    end   
    puts "The total income of a day is #{cost_price_list.sum}"
end

$cash_box ={'1' => 0,'1c' => 0,'2' => 0,'2c' => 0,'5' => 1,'5c' => 1,'10' => 0,'10c' => 0,'20' => 2,'50' => 1,'100' => 0,'200' => 1,'500' => 0,'2000' => 0}
open_shop

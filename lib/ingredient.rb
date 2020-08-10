class Ingredient

    attr_accessor :ingredientName

    def show_ingredient 
       get_ingredient

       @ingredientArray.each do |x|
            puts "Ingredient: #{x[1]}"
            puts "Price: $#{x[2]}"
            puts "Recipes:"
            @ingredientID = x[0]
            get_ingredient_recipes
            @ingredientRecipesArray.each do |y|
                puts y
            end
            puts
       end
    end

    def get_ingredient_recipes
       @ingredientRecipesArray = Array.new
       command = DB.prepare "SELECT Recipes.recipeName FROM Recipes JOIN joiner ON Recipes.recipeID=joiner.recipeID WHERE joiner.ingredientID=#{@ingredientID}"
       reader = command.execute
       reader.each do |recipe|
           @ingredientRecipesArray << recipe[0]
       end
       command.close if command
   end

    def get_ingredient
        @ingredientArray = Array.new
        if @ingredientName == nil
            command = DB.prepare "SELECT * FROM Ingredients"
            reader = command.execute
            reader.each do |y|
                @ingredientArray << y 
            end
            command.close if command
        else 
            command = DB.prepare "SELECT * FROM Ingredients WHERE ingredient='#{@ingredientName}'"
            reader = command.execute
            reader.each do |y|
                @ingredientArray << y
            end
            command.close if command
        end   
    end

    def get_recipes
        recipesArray = Array.new
        command = DB.prepare "SELECT Recipes.recipeName FROM Recipes JOIN joiner ON Recipes.recipeID=joiner.recipeID WHERE joiner.ingredientID=(SELECT Ingredients.ingredientID FROM Ingredients WHERE Ingredients.ingredient='#{@ingredientName}')"
        reader = command.execute
        reader.each do |x|
            recipesArray << x[0]
        end
        command.close if command
        return recipesArray
    end
end

def compare_ingredients
    ingredientsArray = Array.new
    command = DB.prepare "SELECT ingredient FROM Ingredients"
    reader = command.execute
    reader.each do |x|
        ingredientsArray << x[0]
    end
    command.close if command
    # print ingredientsArray

    # puts ingredientsArray.length

    # ingredientsArray.each do |ingredient|
    #     var = ingredient
    #     puts "var is #{var}"
    #     puts "ingredient is #{ingredient}"
    #     var = Ingredient.new
    #     var.ingredientName = ingredient
    #     recipesArray = var.get_recipes
    #     puts
    # end

    most_shared = 0
    most_shared_ing = ""
    while ingredientsArray.length != 0
        i = 0
        x = 1
        (0..ingredientsArray.length).each do
            var = ingredientsArray[i]
            var1 = ingredientsArray[x]

            # puts "var is #{ingredientsArray[i]}"
            # puts "var1 is #{ingredientsArray[x]}"

            var = Ingredient.new
            var.ingredientName = ingredientsArray[i]
            var.get_recipes

            var1 = Ingredient.new
            var1.ingredientName = ingredientsArray[x]
            var1.get_recipes

            sharedrecipesArray = Array.new
            sharedrecipesArray = var.get_recipes & var1.get_recipes
            # print "sharedrecipesArray = #{sharedrecipesArray}"
            # puts
            # puts sharedrecipesArray.length
            # puts
            if most_shared < sharedrecipesArray.length 
                most_shared = sharedrecipesArray.length
                most_shared_ing = ingredientsArray[i] + ingredientsArray[x]
            end
            # puts "most_shared is #{most_shared}"
            # puts "most_shared_ing is #{most_shared_ing}"
            x = x + 1
        end
        ingredientsArray.delete_at(0)
        # print ingredientsArray
    end
    puts "most_shared is #{most_shared}"
    puts "most_shared_ing is #{most_shared_ing}"
end

def add_ingredient i, p
    command = DB.prepare "INSERT INTO Ingredients (ingredient, ingredientPrice) VALUES ('#{i}', #{p})"
    command.execute
    command.close if command
end

def check_ingredient x
    newIngredientArray = Array.new
    recipeArray = Array.new
    tempVar = ""
    x.each_char do |letter|
        if letter == ","
            recipeArray << tempVar
            tempVar = ""
        else
            tempVar = tempVar + letter
        end
    end
    recipeArray << tempVar

    ingredientArray = Array.new
    command = DB.prepare "SELECT ingredient FROM Ingredients"
    reader = command.execute
    reader.each do |y|
        ingredientArray << y[0]
    end
    command.close if command

    recipeArray.each do |recipeIngredient|
        if ingredientArray.include?(recipeIngredient)
            #puts "#{recipeIngredient} already exists"
        else
            newIngredientArray << recipeIngredient
            #puts "#{recipeIngredient} does not exist"
        end
    end
    return newIngredientArray
end

def get_ingredientIDs i
    sql = i.gsub(",","' OR ingredient='")
    command = DB.prepare "SELECT ingredientID FROM Ingredients WHERE ingredient='#{sql}'"
    reader = command.execute
    ingredientIDArray = Array.new
    reader.each do |y|
        ingredientIDArray << y
    end
    command.close if command
    return ingredientIDArray
end
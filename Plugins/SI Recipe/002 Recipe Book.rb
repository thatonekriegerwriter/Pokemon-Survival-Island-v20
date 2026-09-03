
class RecipeBook
  attr_accessor :recipes

def initialize
   @recipes = []
end

def add(id)
  id = id.id if id.is_a?(ItemData)
  if !has?(id)
    @recipes << id
  end
end

def has?(id)
 @recipes.include?(id)
end
alias unlocked? has?


end




SaveData.register(:recipe_book) do
  ensure_class :RecipeBook 
  save_value { $recipe_book  }
  load_value { |value| $recipe_book = value }
  new_game_value {
    RecipeBook.new
  }
end

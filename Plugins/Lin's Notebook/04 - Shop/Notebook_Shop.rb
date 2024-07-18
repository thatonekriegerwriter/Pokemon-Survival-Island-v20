#===============================================================================
# * Notebook Shop
#===============================================================================

def pbMailShop(items = nil, mails = nil)
  sellItems = []
  items.each { |item| sellItems.push(item)} if items != nil
  mails.each { |item| sellItems.push(item)} if mails != nil
  pbMailMart(sellItems, nil, true)
end

def pbConvertMailToNote(mails)
  for items in mails do
    if $bag.has?(items)
      if GameData::Item.get(items).is_mail?
        NoteConfig::NOTES_BACKGROUND.push(items)
        quantity = $bag.quantity(items)
        $bag.remove(items, quantity)
      end
    end
  end
end
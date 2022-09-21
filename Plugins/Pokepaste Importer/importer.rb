def cutfile(file,pknum) 	#cut the file into a list for every pkmn
	text = File.open(file)
	team=[]
	prov=[]
	for i in 0...pknum
		team.push([])
	end
	text.each do |line| 
		words=line.split
		prov.push words
	end
	k=0
	for list in prov
		if list!=[]
			team[k].push(list)
		else
			k+=1
		end
	end
	return(team)	
end

def nametospecies(name) #make the pkmn name something the game can read
	if name=="Nidoran-M" #nidoran being weird in pbs files
		return(:NIDORANmA)
	end
	if name=="Nidoran-F"
		return(:NIDORANfE)
	end
    GameData::Species.each_species do |species|
	  if species.real_name==name
		return(species.id)
      end
    end
	n=name.split("-")
	GameData::Species.each_species do |species|
	  if species.real_name==n[0]
		return(species.id)
	  end
    end
end

def nametoitem(pkmn,iname)  #make the item name something the game can read
	name=""
	if iname!=nil
		for j in 0...iname.length
			if j==0
				name<<iname[j]
			else
				name<<" "
				name<<iname[j]
			end
		end
		GameData::Item.each do |i|
			if i.real_name==name			
				pkmn.item=i
			end
		end		
	end
end

def nametoabil(pkmn,name) #make the ability name something the game can read
	aname=""
	if name!=nil
		for j in 0...name.length
			if j==0
				aname<<name[j]
			else
				aname<<" "
				aname<<name[j]
			end
		end
		GameData::Ability.each do |abil|
			if abil.real_name==aname
				pkmn.ability=abil
			end
		end	
	end
end

def findform(name,pkmn)	#make the form name something the game can read
	specie=pkmn.species
	n=name.split("-")
	if n.length>1
		exspecie=[:ARCEUS,:GENESECT,:ZACIAN,:SILVALLY,:ZAMAZENTA]
		if n[1]!="Mega" && n[1]!="Primal" && !exspecie.include?(specie) && n[1]!="Complete"
			formcmds = []
			GameData::Species.each do |sp|
				next if sp.species != specie
				form_name = sp.form_name
				form_name = _INTL("Unnamed form") if !form_name || form_name.empty?
				formcmds.push(form_name)
			end
			for i in 0...formcmds.length		#exceptions: pkmn that learn move when changing form
				if formcmds[i].include?(n[1])
					if specie==:CALYREX && i==2
						pkmn.learn_move(:ASTRALBARRAGE)
					end
					if specie==:CALYREX && i==1
						pkmn.learn_move(:GLACIALLANCE)
					end
					if specie==:NECROZMA && i==1
						pkmn.learn_move(:SUNSTEELSTRIKE)
					end
					if specie==:NECROZMA && i==2
						pkmn.learn_move(:MOONGEISTBEAM)
					end
					if specie==:KYUREM && i==1
						pkmn.learn_move(:ICEBURN)
						pkmn.learn_move(:FUSIONFLARE)
					end
					if specie==:KYUREM && i==2
						pkmn.learn_move(:FREEZESHOCK)
						pkmn.learn_move(:FUSIONBOLT)
					end
					if specie==:ROTOM
						pkmn.learn_move(:OVERHEAT) if i==1
						pkmn.learn_move(:HYDROPUMP) if i==2
						pkmn.learn_move(:BLIZZARD) if i==3
						pkmn.learn_move(:AIRSLASH) if i==4
						pkmn.learn_move(:LEAFSTORM) if i==5
					end

					return(i)
				end
			end
		end
		if specie==:GRENINJA
			if n[1]=="Ash"
				return(1)
			end
		end
	end	
	return 0
end

def giveev(pkmn,value,evname)  #obvious
	if evname=="Atk"
		stat=:ATTACK
	elsif evname=="SpA"
		stat=:SPECIAL_ATTACK
	elsif evname=="Spe"
		stat=:SPEED
	elsif evname=="HP"
		stat=:HP
	elsif evname=="Def"
		stat=:DEFENSE
	else
		stat=:SPECIAL_DEFENSE
	end
	pkmn.ev[stat]=value
end

def giveiv(pkmn,value,ivname)
	stat=false
	if ivname=="Atk"
		stat=:ATTACK
	elsif ivname=="SpA"
		stat=:SPECIAL_ATTACK
	elsif ivname=="Spe"
		stat=:SPEED
	elsif ivname=="HP"
		stat=:HP
	elsif ivname=="Def"
		stat=:DEFENSE
	elsif ivname=="SpD"
		stat=:SPECIAL_DEFENSE
	else
		echoln(ivname)
	end
	pkmn.iv[stat]=value
end

def nametonature(name)
	GameData::Nature.each do |nature|
		if nature.real_name==name
			return nature.id
		end
	end
end

def nametomove(pkmn,name)
	aname=""
	if name!=nil
		for j in 0...name.length
			if j==0
				aname<<name[j]
			else
				aname<<" "
				aname<<name[j]
			end
		end
		if aname!="Behemoth Bash" || aname!="Behemoth Blade"	#zacian and zamazenta
			pkmn.learn_move(:IRONHEAD)
		end
		GameData::Move.each do |move|
			if move.real_name==aname && aname!="Behemoth Bash" && aname!="Behemoth Blade"
				pkmn.learn_move(move)
			end
		end
	end
end

def caracpkmn(pktext)
	id=nametospecies(pktext[0][0])
	pkmn = Pokemon.new(id,100)
	pkmn.form=findform(pktext[0][0],pkmn)
	if pktext[0][1]=="@"
		nametoitem(pkmn,pktext[0][2...pktext[0].length])
	else
		nametoitem(pkmn,pktext[0][3...pktext[0].length])
		if pktext[0][1]=="(M)"
			pkmn.makeMale 
		else
			pkmn.makeFemale
		end
	end
	nametoabil(pkmn,pktext[1][1...pktext[1].length])
	i=2
	if i<pktext.length
		if pktext[i][0]=="Level:"
			pkmn.level=(pktext[i][1]).to_i
			i+=1
		end
	end
	if i<pktext.length
		if pktext[i][0]=="Shiny:"
			pkmn.shiny=true if pktext[i][1]=="Yes"
			i+=1
		end
	end
	if i<pktext.length
		if pktext[i][0]=="Happiness:"
			pkmn.happiness=(pktext[i][1]).to_i
			i+=1
		end
	end
	if i<pktext.length	
		if pktext[i][0]=="EVs:"
			for j in 0...pktext[i].length/3
				giveev(pkmn,(pktext[i][j*3+1]).to_i,pktext[i][j*3+2])
			end
			i+=1
		end
	end
	if i<pktext.length	
		if pktext[i][1]=="Nature"
			pkmn.nature=nametonature(pktext[i][0])
			i+=1
		end
	end
	if i<pktext.length	
		if pktext[i][0]=="IVs:"
			for j in 0...pktext[i].length/3
				giveiv(pkmn,(pktext[i][j*3+1]).to_i,pktext[i][j*3+2])
			end
			i+=1
		end
	end
	for j in 0...4
		if i<pktext.length	
			if pktext[i][0]=="-"
				nametomove(pkmn,pktext[i][1...pktext[i].length])
				i+=1
			end
		end	
	end
	pkmn.calc_stats
	return(pkmn)
end	

def genteam(file,inf,sup)	#main script
	cut=cutfile(file,sup)
	for i in inf...sup
		pbAddPokemon(caracpkmn(cut[i]))
	end
end



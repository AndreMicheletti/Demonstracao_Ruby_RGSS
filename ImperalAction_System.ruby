#==============================================================================
# ** Imperial Action System I -- Main Script
#==============================================================================
# Autor: AndreMaker ou Maker-Leon ou Leon-S.K
#==============================================================================
#  Este é o script da maioria das definições do ABS... Não Mecha se nao souber
# o que esta fazendo
#==============================================================================

#==============================================================================
#                             -- ATENÇÃO --
#  Coloque este script sempre abaixo do script 'Imperial Configuration'
#==============================================================================

class Game_Event < Game_Character
  
  include Imperial
  include Imperial_Config
  
  attr_accessor :minibar
  attr_reader :enemy
  attr_reader :object
  attr_reader :killed
  attr_reader :attacking
  
  alias abs_initialize initialize
  def initialize(map_id, event)
    @enemy = nil; @object = nil
    @killed = false; @attacking = false; @performing = false
    @recover = 0; @timer = 0; @shield_count = 0; @recover_skill = 0
    @state_steps = []
    abs_initialize(map_id, event)
  end
  
  alias abs_moving? moving?
  def moving?
    if @enemy.nil? and @object.nil?
      return abs_moving?
    end
    if !@enemy != nil
      return abs_moving?
    end
    if not_move?(@enemy.enemy)
      if @restriction.nil?
        @restriction = States::Move_Restriction 
      else
        @restriction -= 1
        if @restriction == 0
          @restriction = nil
          @enemy.enemy.states.each {|state|
            next if !States::Not_Move.include?(state.id)
            @enemy.enemy.remove_state(state.id)
          }
        end
      end
      if not $game_map.damage_sprites.any? {|sprite| next if !sprite.is_a?(Sprites::Custom); sprite.text == "Cannot Move!" and sprite.target == self}
        $game_map.damage_sprites.push(Sprites::Custom.new(self,"Cannot Move!"))
      end
      return true
    end
    abs_moving?
  end
  
  alias abs_setup_page_settings setup_page_settings
  def setup_page_settings
    abs_setup_page_settings
    check_enemy
  end
  
  def perform_kill
    return if @killed
    @performing = true
    @opacity > 0 ? @opacity -= 10 : @killed = true
    if @killed
      make_drops
      @performing = false
      if !Enemy_Effects::Die_SE[@enemy.id].nil?
        RPG::SE.new(Enemy_Effects::Die_SE[@enemy.id],90).play
      end
      case @enemy.die
      when 0
        @enemy = nil
        self.erase
      when 1
        key = [$game_map.map_id, self.id, @enemy.switch]
        if $game_self_switches[key] == true
          $game_self_switches[key] = false
        else
          $game_self_switches[key] = true
        end
        @opacity = 255
      when 2
        if $game_switches[@enemy.switch] == true
          $game_switches[@enemy.switch] = false
        else
          $game_switches[@enemy.switch] = true
        end
        @opacity = 255
      end
    end
  end
    
  def make_drops
    inimigo = $data_enemies[@enemy.id]
    if !inimigo.gold.nil?
      if inimigo.gold > 0
        $game_map.drops.push(Drop.new(self, 1,true,inimigo.gold))
      end
    end
    return if inimigo.drop_items.empty?
    i = 1
    inimigo.drop_items.each { |item|
      if item.denominator == 1
        i += 1
        case item.kind
        when 1
          $game_map.drops.push(Drop.new(self, i, false,$data_items[item.data_id]))
        when 2
          $game_map.drops.push(Drop.new(self, i, false,$data_weapons[item.data_id]))
        when 3
          $game_map.drops.push(Drop.new(self, i, false,$data_armors[item.data_id]))
        end
      else
        r = rand(item.denominator)
        if r == item.denominator - 1
          i += 1
          case item.kind
          when 1
            $game_map.drops.push(Drop.new(self, i, false,$data_items[item.data_id]))
          when 2
            $game_map.drops.push(Drop.new(self, i, false,$data_weapons[item.data_id]))
          when 3
            $game_map.drops.push(Drop.new(self, i, false,$data_armors[item.data_id]))
          end
        end
      end
    }
  end
  
  def check_enemy
    if !@enemy.nil?
      @enemy = nil
      $game_map.enemies.delete(self) if $game_map.enemies.include?(self)
    end
    if !@object.nil?
      @object = nil
      $game_map.enemies.delete(self) if $game_map.enemies.include?(self)
    end
    if !@minibar.nil?
      @minibar.dispose if not @minibar.disposed
      @minibar = nil
    end
    @list.each do |command|
      next if not command.code == 108 or command.code == 408
      if !@enemy.nil?
        check_enemy_command(command)
      end
      if !@object.nil?
        check_object_command(command)
      end
      if command.parameters[0].downcase.include?('enemy ')
        @enemy = Enemy.new(check_enemy_id(command))
        @enemy.die = 0
        $game_map.enemies.push(self)
        print "Inimigo #{@enemy.enemy.name} criado \n"
      elsif command.parameters[0].downcase.include?('object ')
        sub = command.parameters[0].downcase.sub('object ','')
        if sub.include?('self ')
          sub2 = sub.clone; sub2.sub!('self ','')
          @object = ABS_Object.new(sub2.upcase)
        elsif sub.include?('switch ')
          sub2 = sub.clone; sub2.sub!('switch ','')
          @object = ABS_Object.new(sub2.to_i)
        elsif sub.include?('switch ')
          @object = ABS_Object.new(true)
        elsif sub == "puzzle"
          @object = ABS_Object.new(false)
        else
          @object = ABS_Object.new(true)
        end
        $game_map.enemies.push(self)
        print "Objeto criado com switch #{(@object.switch rescue '???')} \n"
      end
    end
    #if @enemy.nil? and @object.nil?
    #  @enemy = Imperial::Enemy.new(1)
    #  @enemy.follow = 0; @enemy.real_event = true
    #  $game_map.enemies.push(self)
    #end
  end
  
  def start_object
    return if @object.nil?
    if @object.breakable == true
      @object.hits -= 1
      return if @object.hits > 0
    end
    case @object.switch.class.to_s
    when "String"
      key = [$game_map.map_id, self.id, @object.switch]
      if $game_self_switches[key] == true
        $game_self_switches[key] = false
      else
        $game_self_switches[key] = true
      end
      @opacity = 255
    when "Fixnum"
      if $game_switches[@object.switch] == true
        $game_switches[@object.switch] = false
      else
        $game_switches[@object.switch] = true
      end
      @opacity = 255
    when "TrueClass"
      start(true)
    when "FalseClass"
      return
    end
  end  
  
  alias abs_start start
  def start(hit = false)
    if @object != nil
      if @object.switch == true
        if hit
          abs_start
        else
          return
        end
      else @object.switch == false
        return
      end
    end
    abs_start
  end
  
  def try_start_object(weapon)
    return if @object.nil?
    if @object.only.nil?
      start_object
    else
      if @object.only != weapon
        @animation_id = 0
        return
      else
        start_object
      end
    end
  end
  
  def check_object_command(command)
    string = command.parameters[0].downcase.clone
    if string.include?('breakable ')
      sub = string.clone; sub.sub!('breakable ','')
      @object.breakable = true
      @object.hits = sub.to_i
    end
    if string.include?('auto cast ')
      sub = string.clone; sub.sub!('auto cast ','')
      @object.auto_cast = $data_skills[sub.to_i]
    end
    if string.include?('weapon ')
      sub = string.clone; sub.sub!('weapon ','')
      @object.only = $data_weapons[sub.to_i]
    elsif string.include?('skill ')
      sub = string.clone; sub.sub!('skill ','')
      @object.only = $data_skills[sub.to_i]
    elsif string.include?('item ')
      sub = string.clone; sub.sub!('item ','')
      @object.only = $data_items[sub.to_i]
    end
  end
  
  def check_enemy_command(command)
    string = command.parameters[0].downcase.clone
    @enemy.die = 0 if string == 'die erase'
    if string.include?('weapon ')
      sub = string.clone; sub.sub!('weapon ','')
      @enemy.only = $data_weapons[sub.to_i]
    elsif string.include?('skill ')
      sub = string.clone; sub.sub!('skill ','')
      @enemy.only = $data_skills[sub.to_i]
    elsif string.include?('item ')
      sub = string.clone; sub.sub!('item ','')
      @enemy.only = $data_items[sub.to_i]
    end
    if string.include?('follow')
      @enemy.follow = string.sub('follow ','').to_i
    end
    if string.include?('die')
      if string.include?('self')
        @enemy.die = 1
        sub = string.clone; sub.sub!('die self ','');
        @enemy.switch = sub.upcase
      elsif string.include?('switch')
        @enemy.die = 2
        sub = string.clone; sub.sub!('die switch ','');
        @enemy.switch = sub.to_i
      end
    end
  end
  
  
  alias im_update update
  def update
    im_update
    if !@object.nil?
      update_auto_cast if @object.auto_cast != nil
      return
    end
    unless @killed
      perform_kill if @performing
      battle_update if @enemy
    else
      update_kill
    end
  end
  
  def update_auto_cast
    @recover_skill = 0 if @recover_skill.nil?
    @recover_skill -= 1 if @recover_skill > 0
    auto_cast(@object.auto_cast) if @recover_skill == 0
  end
  
  def update_kill
    @killed = false if !@enemy.nil?
  end
  
  alias abs_move_straight move_straight
  def move_straight(d, turn_ok = true)
    update_states if @enemy != nil
    abs_move_straight(d, turn_ok)
  end
  
  def update_states
    if not_attack?(@enemy.enemy)
      @enemy.enemy.states.each { |state|
        next if !States::Not_Attack.include?(state.id)
        update_state_steps(state)
      }
    end
    if not_cast?(@enemy.enemy)
      @enemy.enemy.states.each { |state|
        next if !States::Not_Cast.include?(state.id)
        update_state_steps(state)
      }
    end
  end
  
  def update_state_steps(state)
    if state.remove_by_walking
      @state_steps[state.id] = (state.steps_to_remove / 3).to_i if @state_steps[state.id].nil?
      if @state_steps[state.id] > 0
        print @state_steps[state.id],"\n"
        @state_steps[state.id] -= 1 
      else
        @enemy.enemy.remove_state(state.id) 
        @state_steps[state.id] = nil
      end
    end
  end
  
  alias abs_update_movement update_self_movement
  def update_self_movement
    if @enemy.nil? and @object.nil?
      abs_update_movement
      return
    end
    return if @attacking == true or @performing == true
    abs_update_movement
  end
  
  def battle_update
    if Minibar_Always and @minibar.nil?
      @minibar = Sprites::Minibar.new(self)
    end
    if @minibar.is_a?(Sprites::Minibar)
      @minibar.update 
      @minibar = nil if @minibar.disposed?
    end
    return if @performing == true
    @recover -= 1 if @recover > 0
    @recover_skill -= 1 if @recover_skill > 0
    actor = nearest_character(self, real_actors)[0]
    return if actor.nil?
    return if @enemy.follow == 0
    @attacking = (abs_distance_to(self, actor) <= @enemy.follow)
    @ab = false if @ab == true and @attacking == false
    return if !@attacking
    if !@ab
      @balloon_id = 1
      @ab = true
    end
    update_melee if @recover == 0
    update_skill if @recover_skill == 0
  end
  
  def update_melee
    actor = nearest_character(self, real_actors)[0]
    if abs_distance_to(self, actor) > 1
      move_toward_character(actor) if !moving?
    else
      if !facing?(self, actor)
        turn_toward_character(actor) if !moving?
      end
      if melee_ok?(self, actor)
        attack_char(actor)
      else
        move_straight(@direction) if !moving?
      end
    end
  end
  
  def usable_action_skills
    return if @enemy.nil?
    return if @killed or @performing
    result = []
    @enemy.actions.each {|action|
      next if action.skill_id == 1 or action.skill_id == 2
      result.push(action) if Distance_Skills.keys.include?(action.skill_id)
    }
    result
  end
  
  def update_skill
    return if usable_action_skills.nil?
    return if !facing?(self,$game_player)
    target = real_actors.shuffle[0]
    action_now = usable_action_skills.shuffle[0]
    rate_now = rand(10) + 1
    return if action_now.nil?
    if action_now.rating >= rate_now
      skill_id = action_now.skill_id
      if skill_castable?(skill_id, target)
        cast_skill(skill_id)
        @recover_skill = Default_RecoverSkill
        return
      else
        @recover_skill = 40
      end
    else
      @recover_skill = 60
    end
  end
  
  def skill_castable?(skill_id, target)
    return false if @enemy.hp - $data_skills[skill_id].mp_cost < 0
    if not_cast?(@enemy.enemy)
      update_states
      $game_map.damage_sprites.push(Sprites::Custom.new(self, "Cannot Cast!"))
      return false
    end
    return true if ranged_ok?(self, target, Distance_Skills[skill_id][2])
  end
  
  def cast_skill(skill_id)
    skill = $data_skills[skill_id]
    array = Distance_Skills[skill_id]
    RPG::SE.new(array[5],80).play
    @enemy.mp -= skill.mp_cost
    @recover_skill = array[0]
    $game_map.characters.push(Ranged::Enemy_Skill.new(array[1],array[2],array[3],array[4],skill,self))
  end
  
  def auto_cast(skill)
    if Distance_Skills[skill.id].nil?
      @object.auto_cast = nil
      return
    end
    array = Distance_Skills[skill.id]
    RPG::SE.new(array[5],80).play
    @recover_skill = array[0]
    $game_map.characters.push(Ranged::Enemy_Skill.new(array[1],array[2],array[3],array[4],skill,self))
  end
  
  def breaked_defense?
    return true if @enemy.atk > $game_party.members[0].def
    return true if @enemy.agi > $game_party.members[0].agi + $game_party.members[0].luk
    return false
  end
  
  def attack_char(char)
    return if @enemy.nil? or @killed
    @recover = Default_RecoverMain
    if not_attack?(@enemy.enemy)
      update_states
      $game_map.damage_sprites.push(Sprites::Custom.new(self, "Cannot Attack"))
      return
    end
    if @enemy.weapon != nil and Show_Weapon_Sprites
      SceneManager.scene.spriteset.enemy_attack(self, @enemy.weapon)
    end
    if !Enemy_Effects::Attack_SE[@enemy.id].nil?
      if !Enemy_Effects::Attack_SE[@enemy.id].empty?
        r = rand(Enemy_Effects::Attack_SE[@enemy.id].size)
        se_now = Enemy_Effects::Attack_SE[@enemy.id][r]
        RPG::SE.new(se_now, 80).play
      end
    end
    if char.is_a?(Game_Player)
      if $game_player.shielding
        if $game_player.facing?($game_player, self)
          breaked = breaked_defense?
          if !breaked
            $game_map.damage_sprites.push(Sprites::Custom.new($game_player, "Block!"))
            RPG::SE.new(Shield::SE, 80).play
            return
          end
        end
      end
    end
    damage_hero(char, @enemy.atk, self, @enemy.crit?)
  end
end

#==============================================================================#

class Game_Player < Game_Character
  
  include Imperial
  include Imperial_Config
  
  attr_accessor :killed
  attr_accessor :shielding
  attr_accessor :aiming
  attr_accessor :selected_skill
  attr_accessor :selected_buff
  attr_accessor :selected_item
  attr_accessor :not_evade
  attr_accessor :last_enemy_hitted
  attr_accessor :minibar
  attr_accessor :hit
  attr_accessor :skill_hit
  attr_accessor :player_need_refresh
  attr_accessor :stance
  attr_reader   :distance_now
  attr_reader   :scanning
  
  alias im_initialize initialize
  alias im_update update
  alias im_movable movable?

  def initialize
    @recover_main = 0; @recover_off = 0; @recover_skill = 0; @recover_item = 0
    @killed = false, @shielding = false, @not_evade = false; @hit = 0;
    @skill_hit = 0; @scanning = false;
    im_initialize
  end
  
  def update
    im_update
    return if @vehicle_type != :walk
    if !@killed
      battle_update
    else
      if $game_party.members[0] != nil
        @killed = false if $game_party.members[0].hp > 0
      end
    end
  end
  
  def battle_update
    return if @vehicle_type != :walk
    @recover_main -= 1 if @recover_main > 0
    @recover_off -= 1 if @recover_off > 0
    @recover_skill -= 1 if @recover_skill > 0
    @recover_item -= 1 if @recover_item > 0
    if Minibar_Always and @minibar.nil?
      @minibar = Sprites::Minibar.new(self)
    end
    if @minibar.is_a?(Sprites::Minibar)
      @minibar.update 
      @minibar = nil if @minibar.disposed?
    end
    if @stance.nil?
      @stance = :attack
      $game_system.hud_need_refresh = true
    end
    update_inputs
  end
  
  def update_inputs
    return if @vehicle_type != :walk
    if Input.trigger?(Main_Hand_Key)
      if Distance_Weapons.keys.include?($game_party.members[0].weapons[0].id)
        update_ranged if @recover_main == 0 and !@shielding 
      else
        update_main_attack if @recover_main == 0 and !@shielding
      end
    end
    if Shield::Enabled
      if $game_party.members[0].dual_wield?
        if Input.trigger?(Off_Hand_Key)
          update_off_attack if @recover_off == 0
        end
      else
        if !moving?
          @shielding = Input.press?(Off_Hand_Key)
        end
      end
    else
      if $game_party.members[0].dual_wield?
        if Input.trigger?(Off_Hand_Key)
          update_off_attack if @recover_off == 0
        end
      end
    end
    if Input.press?(Change_SelectionKey) and !moving?
      @pressing = true
      if Input.trigger?(SkillCast_Key)
        change_selected_skill
      end
      if Input.trigger?(BuffCast_Key)
        change_selected_buff
      end
      if Input.trigger?(ItemUse_Key)
        change_selected_item
      end
      if Input.trigger?(Followers::Stance_AttackKey)
        @stance = :attack
        $game_system.hud_need_refresh = true
      elsif Input.trigger?(Followers::Stance_DefendKey)
        @stance = :defend
        $game_system.hud_need_refresh = true
      end
    else
      @pressing = false
      if Input.trigger?(SkillCast_Key)
        update_skill_cast if @recover_skill == 0
      end
      if Input.trigger?(BuffCast_Key)
        update_buff_cast if @recover_skill == 0
      end
      if Input.trigger?(ItemUse_Key)
        update_item_use if @recover_item == 0
      end
    end
  end
  
  def update_item_use
    return if @vehicle_type != :walk
    return if @selected_item == nil
    return if @recover_item > 0
    item_use(@selected_item)
  end
  
  def item_use(item)
    return if @vehicle_type != :walk
    $game_party.members[0].item_apply($game_party.members[0], item)
    $game_party.consume_item(item)
    @selected_item = nil if $game_party.item_number(item) == 0
    $game_system.hud_need_refresh = true
  end
  
  
  def update_buff_cast
    return if @vehicle_type != :walk
    return if @selected_buff == nil
    return if @recover_skill > 0
    if skill_ok?(@selected_buff)
      buff_cast(@selected_buff)
    end
  end
  
  def buff_cast(skill)
    return if @vehicle_type != :walk
    array = Buff_Skills[skill.id]
    @recover_skill = array[0]
    buff_cast!(self, skill)
  end
    
  def update_skill_cast
    return if @vehicle_type != :walk
    return if @selected_skill == nil
    return if @recover_skill > 0
    if skill_ok?(@selected_skill)
      skill_cast(@selected_skill)
    end
  end
  
  def skill_cast(skill)
    return if @vehicle_type != :walk
    array = Distance_Skills[skill.id]
    @recover_skill = array[0]
    $game_map.characters.push(Ranged::Hero_Skill.new(array[1], array[2], array[3], array[4], skill, self))
    RPG::SE.new(array[5], 80).play rescue RPG::SE.new("Saint9", 80).play
    $game_party.members[0].mp -= skill.mp_cost
  end
  
  def skill_ok?(skill)
    return if @vehicle_type != :walk
    return false if skill.nil?
    return false if !skill.is_a?(RPG::Skill)
    return false if $game_party.members[0].mp - skill.mp_cost < 0
    if not_cast?($game_party.members[0])
      @recover_skill = 60
      $game_map.damage_sprites.push(Sprites::Custom.new(self,"Cannot Cast"))
      return false 
    end
    return true
  end
  
  def usable_skills
    skills = $game_party.members[0].skills
    return [] if skills.empty?
    result = []
    skills.each {|skill|
      next if !Distance_Skills.keys.include?(skill.id)
      result.push(skill)
    }
    result
  end
  
  def usable_buffs
    skills = $game_party.members[0].skills
    return [] if skills.empty?
    result = []
    skills.each {|skill|
      next if !Buff_Skills.keys.include?(skill.id)
      result.push(skill)
    }
    result
  end
  
  def usable_items
    items = $game_party.items
    actor = $game_party.members[0]
    return if items.empty? or actor.nil?
    result = []; munitions = []
    Distance_Weapons.values.each {|array|
      munitions.push(array[3])
    }
    items.each {|item| result.push(item) if actor.usable?(item) and !munitions.include?(item.id) }
    result
  end
  
  def change_selected_skill
    return if usable_skills.nil?
    if usable_skills.empty?
      @selected_skill = nil
      return
    end
    if @selected_skill.nil?
      @selected_skill = usable_skills[0]
      return
    else
      if usable_skills.size == 1
        @selected_skill = usable_skills[0]
        return
      end
      if usable_skills.include?(@selected_skill)
        index = usable_skills.index(@selected_skill)
        if index == usable_skills.size
          @selected_skill = usable_skills[0]
          return
        else
          @selected_skill = usable_skills[index + 1]
          return
        end
      else
        @selected_skill = nil
        return
      end
    end
  end
  
  def change_selected_buff
    return if usable_buffs.nil?
    if usable_buffs.empty?
      @selected_buff = nil
      return
    end
    if @selected_buff.nil?
      @selected_buff = usable_buffs[0]
      return
    else
      if usable_buffs.size == 1
        @selected_buff = usable_buffs[0]
        return
      end
      if usable_buffs.include?(@selected_buff)
        index = usable_buffs.index(@selected_buff)
        if index == usable_buffs.size
          @selected_buff = usable_buffs[0]
          return
        else
          @selected_buff = usable_buffs[index + 1]
          return
        end
      else
        @selected_buff = nil
        return
      end
    end
  end
  
  def change_selected_item
    return if usable_items.nil?
    if usable_items.empty?
      @selected_item = nil
      return
    end
    if @selected_item.nil?
      @selected_item = usable_items[0]
      return
    else
      if usable_items.size == 1
        @selected_item = usable_items[0]
        return
      end
      if usable_items.include?(@selected_item)
        index = usable_items.index(@selected_item)
        if index == usable_items.size
          @selected_item = usable_items[0]
          return
        else
          @selected_item = usable_items[index + 1]
          return
        end
      else
        @selected_item = nil
        return
      end
    end
  end
  
  def update_ranged
    return if @vehicle_type != :walk
    return if @recover_main > 0
    if not_attack?($game_party.members[0])
      @recover_main = 60
      $game_map.damage_sprites.push(Sprites::Custom.new(self,"Cannot Attack"))
      return 
    end
    array = Distance_Weapons[$game_party.members[0].weapons[0].id]
    item = ($data_items[array[3]] rescue false)
    if !item.is_a?(FalseClass)
      if !$game_party.items.include?(item)
        RPG::SE.new('Buzzer1',80).play
        @recover_main = 45
        $game_map.damage_sprites.push(Sprites::Custom.new(self, 'No Ammo', Color.new(255,79,25)))
        return
      end
      $game_party.lose_item(item, 1)
    end
    @recover_main = array[0]
    RPG::SE.new(array[4], 80).play
    $game_map.characters.push(Ranged::Hero_Ranged.new(array[1],array[2],array[5],array[6],$game_party.members[0].weapons[0],self))
    SceneManager.scene.spriteset.hero_attack(self, $game_party.members[0].weapons[0],true) if Show_Weapon_Sprites
  end
  
  def update_main_attack
    return if @vehicle_type != :walk
    if !$game_party.members[0].weapons[0].nil?
      SceneManager.scene.spriteset.hero_attack(self, $game_party.members[0].weapons[0]) if Show_Weapon_Sprites
    end
    @recover_main = Default_RecoverMain
    if not_attack?($game_party.members[0])
      $game_map.damage_sprites.push(Sprites::Custom.new(self,"Cannot Attack"))
      return 
    end
    if !Player_Effects::Attack_SE[$game_party.members[0].actor.id].nil?
      r = rand(Player_Effects::Attack_SE[$game_party.members[0].actor.id].size)
      se_now = Player_Effects::Attack_SE[$game_party.members[0].actor.id][r]
      RPG::SE.new(se_now, 80).play
    end
    attakable_enemies.each { |event|
      if melee_ok?(self, event)
        hero = $game_party.members[0]
        damage_enemy(event, hero.atk, self, hero.weapons[0], crit?)
        break
      end
    }
  end
  
  def update_off_attack
    return if @vehicle_type != :walk
    if !$game_party.members[0].weapons[1].nil?
      SceneManager.scene.spriteset.hero_attack(self, $game_party.members[1].weapons[0]) if Show_Weapon_Sprites
    end
    @recover_off = Default_RecoverOff
    if not_attack?($game_party.members[0])
      $game_map.damage_sprites.push(Sprites::Custom.new(self,"Cannot Attack"))
      return 
    end
    attakable_enemies.each { |event|
      if melee_ok?(self, event)
        hero = $game_party.members[0]
        damage_enemy(event, hero.atk, self, hero.weapons[1], crit?)
        break
      end
    }
  end
  
  def movable?
    if @vehicle_type != :walk
      return im_movable
    end
    if (not_move?($game_party.battle_members[0]) rescue false)
      if @restriction.nil?
        @restriction = States::Move_Restriction 
      else
        @restriction -= 1
        if @restriction == 0
          @restriction = nil
          $game_party.battle_members[0].states.each {|state|
            next if !States::Not_Move.include?(state.id)
            $game_party.battle_members[0].remove_state(state.id)
          }
        end
      end
      if not $game_map.damage_sprites.any? {|sprite| next if !sprite.is_a?(Sprites::Custom); sprite.text == "Cannot Move!" and sprite.target == self}
        $game_map.damage_sprites.push(Sprites::Custom.new(self,"Cannot Move!"))
      end
      return false
    end
    return false if @shielding or @pressing
    return im_movable
  end
  
  def crit?
    r = rand(99) + 1
    return true if $game_party.members[0].cri * 100 >= r
    return false
  end
  
  def evaded?
    if not_evade; not_evade = false; return false; end
    r = rand(99) + 1
    return true if $game_party.members[0].eva * 100 >= r
    return false
  end
  
  def perform_kill
    return if @killed
    @performing = true
    return if @vehicle_type != :walk
    @opacity > 0 ? @opacity -= 10 : @killed = true
    if @killed
      @opacity = 0
    end
  end
end

class Game_Battler < Game_BattlerBase
  
  alias apply item_apply
  
  def item_apply(user, item)
    if user == $game_party.members[0]
      player = $game_player
      @result.clear
      @result.used = item_test(user, item)
      @result.missed = (@result.used && rand >= item_hit(user, item))
      @result.evaded = (!@result.missed && rand < item_eva(user, item))
      if @result.hit?
        $game_map.damage_sprites.push(Sprites::Custom.new(player, "Used item!", Color.new(71,255,95)))
        player.animation_id = item.animation_id
        unless item.damage.none?
          @result.critical = (rand < item_cri(user, item))
          make_damage_value(user, item)
          execute_damage(user)
        end
        item.effects.each {|effect|item_effect_apply(user, item, effect) }
        item_user_effect(user, item)
      else
        $game_map.damage_sprites.push(Sprites::Custom.new(player, "Failed"))
        $game_party.gain_item(item, 1, false, true)
      end
    else
      apply(user, item)
    end
  end
end

class Game_Party < Game_Unit
  
  include Imperial_Config
  
  alias metodo_aliasado_com_sucesso gain_item
  alias metodo_aliasado_success gain_gold

  def gain_item(item, amount, include_equip = false, not_pop = false)
    if amount < 0
      not_pop = true
    end
    if not_pop
      metodo_aliasado_com_sucesso(item, amount, include_equip)
      return
    end
    if Show_Item_Windows
      $game_system.hud_need_refresh = true
      $game_map.windows.push(Imperial::Pop.new(item)) if not amount < 0 and !include_equip
    end
    metodo_aliasado_com_sucesso(item, amount, include_equip)
  end
  
  def gain_gold(amount)
    if Show_Item_Windows
      $game_map.windows.push(Imperial::Pop.new(amount, true)) if not amount < 0
    end
    metodo_aliasado_success(amount)
  end
end
#------------------------------------------------------------------------------
class Game_Follower < Game_Character
  
  include Imperial
  include Imperial_Config
  
  attr_accessor :killed
  attr_accessor :not_evade
  attr_accessor :minibar
  attr_accessor :recover_main
  attr_accessor :recover_off
  attr_accessor :recover_skill
  attr_accessor :enemies_around
  attr_accessor :target
  attr_accessor :battle
  attr_accessor :hit
  attr_reader   :member_index
  attr_reader   :bugged_it_all
  
  alias mas_initialize initialize
  alias mas_update update
  alias mas_gather gather?
  alias mas_chase chase_preceding_character
  
  def initialize(member_index, preceding_character)
    @battle = Followers::Enabled
    if @battle
      @count = 0
      @killed = false; @not_evade = false
      @recover_main, @recover_off, @recover_skill, = 0,0,0
    end
    mas_initialize(member_index, preceding_character)
  end
  
  def chase_preceding_character
    if !$game_player.normal_walk?
      mas_chase
      return
    end
    return if @target
    mas_chase
  end
  
  def update
    super
    if !$game_player.normal_walk?
      mas_update
      return
    end
    if !Followers::Enabled
      mas_update 
    else
      if @killed
        @transparent = true if !@transparent
        @through = true if !@through; @target = nil if !@target.nil?
        chase_preceding_character
        if !$game_party.battle_members[@member_index].nil?
          @killed = false if $game_party.battle_members[@member_index].hp >= 1
        end
      else
        if !$game_party.battle_members[@member_index].nil?
          if $game_party.battle_members[@member_index].hp <= 0
            perform_kill if @performing
            return
          end
        else
          @killed = true
          return
        end
        @through = false if @through
        @opacity = 255 if @opacity != 255
        @transparent = false if @transparent
        @move_speed = $game_player.real_move_speed
        battle_update if @battle
      end
    end
  end
  
  def battle_update
    return if !SceneManager.scene.is_a?(Scene_Map)
    return if $game_party.battle_members[@member_index].nil?
    if Minibar_Always and @minibar.nil?
      @minibar = Sprites::Minibar.new(self)
    end
    if @minibar.is_a?(Sprites::Minibar)
      @minibar.update 
      @minibar = nil if @minibar.disposed?
    end
    @through = false if @through
    @recover_main -= 1 if @recover_main > 0
    @recover_off -= 1 if @recover_off > 0
    @recover_skill -= 1 if @recover_skill > 0
    if @wait_until_return
      @target = nil; @object = nil
      if abs_distance_to(self, $game_player) <= @member_index
        @wait_until_return = false 
      end
      chase_preceding_character
    end
    if $game_player.stance == :defend
      if @target != nil
        @wait_until_return = true
      end
      return
    end
    if @target.nil? and @wait_until_return != true
      refresh_target
    else
      if not @target.nil?
        if @x == @target.x and @y == @target.y
          move_random if !moving?
        end
      end
      return if @target.nil?
      @target = target_valid?
      update_attack_target
    end
  end
    
  def real_objects
    result = []
    $game_map.enemies.each {|event|
      next if event.object.nil?
      next if event.object.auto_cast != nil
      if event.object.only != nil
        next if event.object.only != $game_party.members[@member_index].weapons[0]
      end
      result.push(event) if abs_distance_to(self, event) < Followers::Distance_Battle
    }
    result
  end
    
  def update_attack_target
    return if @target.nil?
    ranged = weapon_ranged?
    update_skills_attacks
    @wait_until_return = (abs_distance_to(self, $game_player) > Followers::Follow_Leader)
    return if @wait_until_return
    if !ranged
      if distance_from_target > 1
        move_toward_character(@target) if !moving?
        @count += 1
        if @count > Followers::Distance_Battle + 2
          @count = 0
          @target = nil
          @wait_until_return = true
          return
        end
      else
        @count = 0 if @count != 0
        turn_toward_character(@target) if !facing?(self, @target)
        update_melee_attacks
      end
    else
      actor = $game_party.battle_members[@member_index]
      array = Distance_Weapons[actor.weapons[0].id]
      if abs_distance_to(self, @target) < array[2]
        turn_toward_character(@target) if !facing?(self, @target)
        update_ranged
      else
        move_toward_character(@target) if !moving?
      end
    end
  end
  
  def target_valid?
    return nil if @target.nil?
    return nil if @target.enemy.nil?
    return nil if @target.enemy.hp <= 0
    return nil if !real_enemies.include?(@target)
    ax = @x - @target.x
    ay = @y - @target.y
    case direction
    when 2
      if ax == 0 and ay < 0
        return nil if (!passable?(@x, @y - 1, 2) or !passable?(@x, @y - 2, 2))
      end
    when 4
      if ay == 0 and ay > 0
        return nil if (!passable?(@x, @y - 1, 4) or !passable?(@x, @y - 2, 4))
      end
    when 6
      if ay == 0
        return nil if (!passable?(@x, @y - 1, 6) or !passable?(@x, @y - 2, 6))
      end
    when 8
      if ax == 0 and ay > 0
        return nil if (!passable?(@x, @y - 1, 8) or !passable?(@x, @y - 2, 8))
      end
    end
    return @target
  end
  
  def distance_from_target
    return if @target.nil?
    return abs_distance_to(self, @target)
  end
  
  def weapon_ranged?
    actor = $game_party.battle_members[@member_index]
    return false if actor.nil?
    return false if actor.weapons[0].nil?
    return true if Distance_Weapons.keys.include?(actor.weapons[0].id)
    return false
  end
  
  def update_ranged
    return if @recover_main > 0
    actor = $game_party.battle_members[@member_index]
    array = Distance_Weapons[actor.weapons[0].id]
    if not_attack?(actor)
      @recover_main = 60
      $game_map.damage_sprites.push(Sprites::Custom.new(self,"Cannot Attack"))
      return 
    end
    if ranged_ok?(self, @target, array[2])
      w = actor.weapons[0]
      SceneManager.scene.spriteset.hero_attack(self,w,true) if Show_Weapon_Sprites
      $game_map.characters.push(Ranged::Hero_Ranged.new(array[1],array[2],array[5],array[6],w,self))
      RPG::SE.new((array[4] rescue "Bow1"),80).play
      @recover_main = array[0]
    else
      move_toward_character(@target) if !moving?
    end
  end
  
  def update_skills_attacks
    return if @recover_skill > 0
    if rand(2) == 0
      @recover_skill = 80
      return
    end
    actor = $game_party.battle_members[@member_index]
    return if actor.nil?
    if !usable_buffs.empty?
      if actor.hp * 100 <= actor.mhp * 50
        buff_now = usable_buffs.shuffle[0]
        if buff_castable?(buff_now)
          cast_buff(buff_now)
          return
        end
      end
    end
    return if usable_skills.empty?
    skill_now = usable_skills.shuffle[0]
    if skill_ok?(skill_now)
      cast_skill(skill_now)
    else
      @recover_skill = 60
    end
  end
  
  def buff_castable?(buff)
    array = Buff_Skills[buff.id]
    actor = $game_party.battle_members[@member_index]
    return false if actor.nil?
    return false if buff.damage.to_hp? and actor.hp == actor.mhp
    return false if buff.damage.to_mp? and actor.mp == actor.mmp
    return false if actor.mp - buff.mp_cost < 0
    return false if @recover_skill > 0
    return true
  end
  
  def cast_buff(buff)
    array = Buff_Skills[buff.id]
    actor = $game_party.battle_members[@member_index]
    @recover_skill = array[0] + 10
    return if actor.nil?
    buff_cast!(self, buff)
    actor.mp -= buff.mp_cost
  end
  
  def usable_buffs
    return [] if @killed
    return [] if actor.nil?
    result = []
    result if actor.skills.empty?
    actor.skills.each {|skill|
      result.push(skill) if Buff_Skills.keys.include?(skill.id)
    }
    result
  end
  
  def cast_skill(skill)
    array = Distance_Skills[skill.id]
    actor = $game_party.battle_members[@member_index]
    @recover_skill = array[0] + 10
    return if actor.nil?
    actor.mp -= skill.mp_cost
    RPG::SE.new((array[5] rescue "Saint9"),80).play
    $game_map.characters.push(Ranged::Hero_Skill.new(array[1], array[2], array[3], array[4], skill, self))
  end
  
  def skill_ok?(skill)
    array = Distance_Skills[skill.id]
    actor = $game_party.battle_members[@member_index]
    return false if actor.nil?
    return true if ranged_ok?(self, @target, array[2]) and actor.mp - skill.mp_cost >= 0
  end
  
  def usable_skills
    return [] if @killed
    return [] if actor.nil?
    result = []
    result if actor.skills.empty?
    actor.skills.each {|skill|
      result.push(skill) if Distance_Skills.keys.include?(skill.id)
    }
    result
  end
  
  def update_melee_attacks
    actor = $game_party.battle_members[@member_index]
    return if actor.nil?
    update_main
  end

  def update_main
    return if @killed
    return if @recover_main > 0
    if melee_ok?(self, @target)
      attack_enemy(@target)
    end
  end
  
  def update_off(weapon)
    return if @killed
    return if @target.nil?
    return if weapon.nil?
    return if @recover_off > 0
    if melee_ok?(@target)
      attack_target(weapon)
      @recover_off = Recover_For_Off_Weapon
    end
  end
  
  def attack_enemy(event)
    return if event.nil?
    @recover_main = Default_RecoverMain + 10
    actor = $game_party.battle_members[@member_index]
    return if actor.nil?
    if actor.weapons[0] != nil and Show_Weapon_Sprites
      SceneManager.scene.spriteset.hero_attack(self, actor.weapons[0])
    end
    damage_enemy(event, actor.atk, self, actor.weapons[0], false)
  end
  
  def update_target_clear
    return true if @target.nil?
    return true if @target.enemy.nil?
    return true if real_enemies.empty?
    return true if @target.enemy.hp <= 0
    return true if abs_distance_to(self, $game_player) >= Followers::Follow_Leader
    return true if distance_from_target >= Followers::Distance_Battle
    return true if !real_enemies.include?(@target)
    return false
  end
  
  def refresh_target
    return if $game_map.enemies.empty?
    battle_range = Followers::Distance_Battle
    real_enemies.shuffle.each {|enemy|
      if abs_distance_to(self, enemy) <= battle_range
        ax = @x - enemy.x
        ay = @y - enemy.y
        case direction
        when 2
          if ax == 0 and ay < 0
            next if (!passable?(@x, @y - 1, 2) or !passable?(@x, @y - 2, 2))
          end
        when 4
          if ay == 0 and ay > 0
            next if (!passable?(@x, @y - 1, 4) or !passable?(@x, @y - 2, 4))
          end
        when 6
          if ay == 0
            next if (!passable?(@x, @y - 1, 6) or !passable?(@x, @y - 2, 6))
          end
        when 8
          if ax == 0 and ay > 0
            next if (!passable?(@x, @y - 1, 8) or !passable?(@x, @y - 2, 8))
          end
        end
        @target = enemy; break
      end
    }
  end
  
  def gather?
    if !$game_player.normal_walk?
      @through = true
      return mas_gather
    end
    return true if @killed
    if @battle == false; return mas_gather; else; return @target.nil?; end
  end
    
  def crit?
    return if actor.nil?
    r = rand(99) + 1
    return true if actor.cri * 100 >= r
    return false
  end
  
  def evaded?
    return if actor.nil?
    if not_evade; not_evade = false; return false; end
    r = rand(99) + 1
    return true if actor.eva * 100 >= r
    return false
  end
  
  def perform_kill
    return if @killed
    @performing = true
    @opacity > 0 ? @opacity -= 10 : @killed = true
    if @killed
      @opacity = 0
      @transparent = true
    end
  end
end

class Game_Party < Game_Unit
  alias swap swap_order
  
  def swap_order(index1, index2, killing = false)
    if killing == false
      if $game_party.battle_members[index1].hp <= 0 or $game_party.battle_members[index2].hp <= 0
        Audio.se_stop
        RPG::SE.new("Buzzer1",80).play
        return
      end
    end
    swap(index1, index2)
    if (index1 or index2) == 0
      $game_player.selected_skill = nil
      $game_player.selected_buff = nil
    end
  end
end
class Game_Actor < Game_Battler
  
  alias message show_added_states
  alias message show_removed_states
  alias message display_level_up
  
  def display_level_up(new_skills)
    $game_party.battle_members.each_with_index {|actor, i|
      next if actor != self
      index = i
    }
    return if index.nil?
    if index == 0
      hero = $game_player
    else
      $game_player.followers.each {|follower|
        next if follower.member_index != index
        hero = follower
      }
    end
    return if hero.nil?
    hero.animation_id = Imperial_Config::LevelUp_Animation
    $game_map.damage_sprites.push(Sprites::Custom.new(hero, "LEVEL UP!"))
  end
  
  def show_added_states
    return if @result.added_state_objects.empty?
    $game_party.battle_members.each_with_index {|actor, i|
      next if actor != self
      index = i
    }
    return if index.nil?
    if index == 0
      hero = $game_player
    else
      $game_player.followers.each {|follower|
        next if follower.member_index != index
        hero = follower
      }
    end
    return if hero.nil?
    $game_map.damage_sprites.push(Sprites::Custom.new(hero, "State added!"))
  end

  def show_removed_states
    return if @result.removed_state_objects.empty?
    $game_party.battle_members.each_with_index {|actor, i|
      next if actor != self
      index = i
    }
    return if index.nil?
    if index == 0
      hero = $game_player
    else
      $game_player.followers.each {|follower|
        next if follower.member_index != index
        hero = follower
      }
    end
    return if hero.nil?
    $game_map.damage_sprites.push(Sprites::Custom.new(hero, "State removed!"))
  end
end
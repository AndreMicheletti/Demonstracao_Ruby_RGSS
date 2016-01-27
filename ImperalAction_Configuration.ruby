#==============================================================================
# ** Imperial Action System I -- Configuration
#==============================================================================
# Autor: AndreMaker ou Maker-Leon ou Leon-S.K
#==============================================================================
#  Este script é o modulo de configurações principal do sistema, é recomendavel
# no minimo ler todas as configurações
#==============================================================================

module Imperial_Config
  
  #--------------------------------------------------------------------------
  # * Configurações Gerais
  #--------------------------------------------------------------------------

  Die_Switch = 1          # Switch ativado quando a party morre
  
  Main_Hand_Key = Key::A  # Tecla de arma primária
  Off_Hand_Key  = Key::S  # Tecla de arma secundaria (ou escudo)
  
  SkillCast_Key = Key::Q  # Tecla de Skill
  BuffCast_Key  = Key::W  # Tecla de Buff
  
  ItemUse_Key   = Key::D  # Tecla de Buff
  Recover_For_Item = 80   # Recover para uso de Items
  
  Change_SelectionKey = Key::Alt  # Tecla que permite a mudança de skill, etc
  
  Minibar_Always = false   # Minibars sempre ligadas? (true/false)
  
  Default_Animation = 1   # Animação Padrao
  Animation_Reduce  = 3   # Redução Animação (padrao 3, não coloque 0)
  LevelUp_Animation = 41  # Animação de Level Up
  
  Show_Weapon_Sprites = true   # Mostrar Sprites de Armas
  Weapon_Sprites_Zoom = 1.2    # Zoom do sprite de armas
  Show_Item_Windows   = true   # Mostrar janela de itens adquiridos
  Show_Damage_Sprites = true   # Mostrar sprites de danos
  Show_Reward_Sprites = false  # Mostrar qnt de EXP ganha
  
  PlayerDie_SE = "die_abyss"   # SE quando um herói morre
  
  Default_EnemyFollow = 4      # Distancia padrão para inimigos seguirem
  
  Default_RecoverMain = 60   # Recover padrão para arma primaria
  Default_RecoverOff  = 60   # Recover padrão para arma secundaria
  Default_RecoverItem = 80   # Recover padrão para uso de items
  Default_RecoverSkill = 80  # Recover padrão para uso de habilidades
  
  
  Gold_Icon_Index = 262      # Index do icone de gold
  PickUp_SE = "Item3"        # SE ao pegar um drop
  
  Jump_On_Damage = false     # Pulo quando recebe dano (true/false)
  
  #--------------------------------------------------------------------------
  # * Configurações de Personalização
  #--------------------------------------------------------------------------

  #--------------------------------------------------------------------------
      Distance_Weapons = {}; Distance_Skills = {}; Buff_Skills = {}
  #--------------------------------------------------------------------------
  
  # Vel = Velocidade
  # Range = Distancia em tiles
  # CN = nome do grafico
  # CI = index do grafico
  
  #Distance_Skills[ID] = [Recover, Vel, Range, CN, CI, SE]
  Distance_Skills[36] = [80, 5, 8, "Energy Ball", 5, "Saint9"]
  Distance_Skills[37] = [80, 5, 8, "Energy Ball", 5, "Saint9"]
  Distance_Skills[39] = [80, 5, 8, "Energy Ball", 5, "Saint9"]
  Distance_Skills[51] = [80, 5, 8, "$Fireball", 0, "Saint9"]
  Distance_Skills[55] = [80, 5, 8, "Energy Ball", 7, "Saint9"]
  Distance_Skills[59] = [80, 5, 8, "Energy Ball", 3, "Saint9"]
  
  #Buff_Skills[ID] = [Recover]
  Buff_Skills[26] = [80]
  
  # Munition = ID do item para sevir de munição para a arma (false para infinito)
  
  #Distance_Weapons[ID] = [Recover, Vel, Range, Munition, SE, CN, CI]
  Distance_Weapons[32] = [70,7,8,false,"Bow1","$Arrow",0]
  
  #--------------------------------------------------------------------------
  # * Configurações de Shielding
  #--------------------------------------------------------------------------

  module Shield
    
    Enabled = true   # Ativo? (true/false)
    
    SE = "Parry"     # SE quando defende
    
  end
  
  #--------------------------------------------------------------------------
  # * Configurações de Estados
  #--------------------------------------------------------------------------

  module States
    
    # Estados que impedem o ataque (IDs)
    Not_Attack = [3]
        
    # Estados que impedem o movimento (IDs)
    Not_Move = [6]
    
    # Estados que impedem o uso de habilidades (IDs)
    Not_Cast = [4]
    
    # Tempo em frames que a restrição de movimento dura
    Move_Restriction = 550
    
  end
  
  #--------------------------------------------------------------------------
  # * Configurações Followers
  #--------------------------------------------------------------------------

  module Followers
    
    Enabled = true        # Ativo? (true/false)
    
    Follow_Leader = 5     # Prioridade para seguir o lider (tiles)
    
    Distance_Battle  = 5  # Prioridade para seguir o inimigo (tiles)
    
    Stance_AttackKey = Key::Right  # Tecla de mudança para a stance attack
    Stance_DefendKey = Key::Left  # Tecla de mudança para a stance defend
    
  end
  
  #--------------------------------------------------------------------------
  # * Configurações de Efeitos para inimigos
  #--------------------------------------------------------------------------

  module Enemy_Effects
    
  #--------------------------------------------------------------------------
                        Attack_SE = {}; Die_SE = []
  #--------------------------------------------------------------------------
  
    # Attack_SE => SE ao inimigo atacar
    # Die_SE    => SE ao inimigo morrer
    
    # ID = ID do inimigo no database
    
    #Attack_SE[ID] = ["SE1", "SE2", "SE3"...]
    Attack_SE[1] = ["Monster1","Monster2"]
    
    #Die_SE[ID] = "SE"
    Die_SE[1] = "Monster3"
    
  end
  
  #--------------------------------------------------------------------------
  # * Configurações de Efeitos para o player
  #--------------------------------------------------------------------------

  module Player_Effects
    
    Attack_SE = {}
  
    # Attack_SE => SE tocado quando o player atacar
    # Para desabilitar, deixe assim:  Attack_SE = []
    
    #Attack_SE = ["SE1", "SE2", "SE3"...]
    Attack_SE[18] = ["voice_1","voice_2","voice_3","voice_4","voice_5","voice_6"]
    Attack_SE[19] = ["voice_1","voice_2","voice_3","voice_4","voice_5","voice_6"]
    Attack_SE[20] = ["f_voice_1","f_voice_2","f_voice_3","f_voice_4","f_voice_5","f_voice_6","f_voice_7"]
    Attack_SE[21] = ["voice_1","voice_2","voice_3","voice_4","voice_5","voice_6"]
    
  end
end

#===============================================================================
#  FIM DAS CONFIGURAÇÕES
#===============================================================================

module Imperial
  
  Melee_Range = {2 => [0,-1], 4 => [1,0], 6 => [0,1], 8 => [0,1]}
  
  Sprite_angles = {2=>[80,110,140,170],4=>[340,10,40,70],6=>[290,260,230,200],8=>[290,320,350,20]}
  Move_correction = {2=>[-8,-10],4=>[0,-10],6=>[0,-4],8=>[4,-10]}
  Sprite_z_values = { 2=>120, 4=>50, 6=>120, 8=>50}
  Shield_correction = {2=>[12,0],4=>[3,0],6=>[16,-3],8=>[2,-5]}
  Shield_z = { 2=>120, 4=>120, 6=>120, 8=>50}
  Shield_angles = {2=>0,4=>-10,6=>10,8=>0}
  
  def distance_to(me, him)
    return if !me.is_a?(Game_Character) or !him.is_a?(Game_Character)
    dx = me.distance_x_from(him.x)
    dy = me.distance_y_from(him.y)
    dx + dy
  end
  
  def abs_distance_to(me, him)
    return if !me.is_a?(Game_Character) or !him.is_a?(Game_Character)
    dx = me.distance_x_from(him.x).abs
    dy = me.distance_y_from(him.y).abs
    (dx + dy).abs
  end
  
  def facing?(me, him)
    return if !me.is_a?(Game_Character) or !him.is_a?(Game_Character)
    ax = me.x - him.x
    ay = me.y - him.y
    case @direction
    when 2
      return true if ax == 0 and ay < 0
    when 4
      return true if ay == 0 and ax > 0
    when 6
      return true if ay == 0 and ax < 0
    when 8
      return true if ax == 0 and ay > 0
    end
    return false
  end
    
  def convert_formula_damage(attacker, defender, formula)
    return if !formula.is_a?(String)
    result = formula.clone
    result.sub!('a.',"#{attacker}.") if result.include?('a.')
    result.sub!('b.',"#{defender}.") if result.include?('b.')
    return result
  end
  
  def convert_formula_heal(user, formula)
    return if !formula.is_a?(String)
    result = formula.clone
    result.sub!('a.',"#{user}.") if result.include?('a.')
    result.sub!('b.',"#{user}.") if result.include?('b.')
    return result
  end
  
  def melee_ok?(me, him)
    return false if !me.is_a?(Game_Character) or !him.is_a?(Game_Character)
    return false if me.killed or him.killed
    return true if facing?(me, him) and abs_distance_to(me, him) <= 1
    return false
  end
  
  def ranged_ok?(me, him, range)
    return false if !me.is_a?(Game_Character) or !him.is_a?(Game_Character)
    return true if facing?(me, him) and abs_distance_to(me,him) <= range
    #return true if facing?(me, him) and path_clear?(me,him,range)
    return false
  end
  
  def path_clear?(me,him,range)
    start_x, start_y = me.x, me.y
    dir = me.direction
    last = range
    case dir
    when 2
      for i in 0..range
        if i == range or i == abs_distance_to(me, him) - 1
          return true
        else
          return false if !me.passable?(start_x, start_y + i, dir) 
        end
      end          
    when 4
      for i in -range..0
        if i == 0 or i == abs_distance_to(me, him) - 1
          return true
        else
          return false if !me.passable?(start_x - i, start_y, dir) 
        end
      end          
    when 6
      for i in 0..range
        if i == range or i == abs_distance_to(me, him) - 1
          return true
        else
          return false if !me.passable?(start_x + i, start_y, dir) 
        end
      end          
    when 8
      for i in -range..0
        if i == 0 or i == abs_distance_to(me, him) - 1
          return true
        else
          return false if !me.passable?(start_x, start_y - i, dir) 
        end
      end          
    end
    return false
  end
  
  def damage_hero(hero, value, enemy, critical = false)
    value *= 2.5 if critical
    value = value.to_i
    hero.jump(0,0) if Imperial_Config::Jump_On_Damage
    rand = (10) - 5
    value -= rand
    hero.animation_id = @enemy.animation
    hero.minibar.nil? ? hero.minibar = Sprites::Minibar.new(hero) : hero.minibar.restart
    if hero.is_a?(Game_Player)
      actor = $game_party.battle_members[0]
      return if actor.nil?
      defense = actor.def - actor.mdf
      value -= defense
      value = 0 if value < 0
      if actor.hp - value <= 0
        actor.hp = 0
        hero.perform_kill
        RPG::SE.new(Imperial_Config::PlayerDie_SE, 80).play
        last_actor_alive = $game_party.alive_members.size
        if last_actor_alive == 0
          $game_switches[Imperial_Config::Die_Switch] = true
          return
        end
        $game_party.swap_order(0, last_actor_alive, true)
        $game_player.followers.each {|follower|
          next if follower.member_index != last_actor_alive
          $game_player.moveto(follower.x, follower.y)
          $game_player.set_direction(follower.direction)
          follower.perform_kill
          follower.transparent = true
        }
      else
        actor.hp -= value
      end
      $game_map.damage_sprites.push(Sprites::Damage.new
              (hero, value, 
              (enemy.enemy.weapon.nil? ? Color.new(255,255,255) : enemy.weapon.color)))
                      if Imperial_Config::Show_Damage_Sprites
    elsif hero.is_a?(Game_Follower)
      actor = $game_party.battle_members[hero.member_index]
      return if actor.nil?
      defense = actor.def - actor.mdf
      value -= defense
      value = 0 if value < 0
      if actor.hp - value <= 0
        actor.hp = 0
        hero.perform_kill
        RPG::SE.new(Imperial_Config::PlayerDie_SE, 80).play
        last_actor_alive = $game_party.alive_members.size
        if last_actor_alive == 0
          $game_switches[Imperial_Config::Die_Switch] = true
          return
        end
        $game_party.swap_order(hero.member_index, last_actor_alive, true)
      else
        actor.hp -= value
      end
      $game_map.damage_sprites.push(Sprites::Damage.new(hero, value, critical)) if Imperial_Config::Show_Damage_Sprites
    else
      return
    end
  end
  
  def not_move?(actor)
    return true if actor.states.any? {|state| Imperial_Config::States::Not_Move.include?(state.id) }
    return false
  end
  
  def not_cast?(actor)
    return true if actor.states.any? {|state| Imperial_Config::States::Not_Cast.include?(state.id) }
    return false
  end
  
  def not_attack?(actor)
    return true if actor.states.any? {|state| Imperial_Config::States::Not_Attack.include?(state.id) }
    return false
  end
  
  def damage_enemy(event, value, hero, weapon, critical = false)
    return if event.enemy.nil? and event.object.nil?
    if weapon.nil?
      event.animation_id = Imperial_Config::Default_Animation
    else
      event.animation_id = weapon.animation_id
    end
    if event.object != nil
      print "try start object \n"
      event.try_start_object(weapon)
      return
    end
    if event.enemy.only != nil
      if event.enemy.only != weapon; event.animation_id = 0; return; end
    end
    rand = (10) - 5
    value -= rand
    event.jump(0,0) if Imperial_Config::Jump_On_Damage
    value *= 2.5 if critical
    value = value.to_i
    evaded = event.enemy.evaded?
    if evaded
      event.jump(0,0)
      $game_map.damage_sprites.push(Sprites::Custom.new(event, "Evade!")) if Imperial_Config::Show_Damage_Sprites
      return
    end
    defense = event.enemy.def - event.enemy.mdf
    value -= defense
    value = 0 if value < 0
    event.minibar.nil? ? event.minibar = Sprites::Minibar.new(event) : event.minibar.restart
    if event.enemy.hp - value <= 0
      $game_map.enemies.delete(event)
      event.enemy.hp = 0
      event.perform_kill
      Audio.se_play('Audio/Se/Blow6', 80, 100)
      expp = event.enemy.enemy.exp
      case hero.class.to_s
      when 'Game_Player'
        actor = $game_party.members[0]
      when 'Game_Follower'
        actor = $game_party.members[hero.member_index]
      end
      actor = $game_party.members[0] if actor.nil?
      actor.gain_exp(expp)
      $game_map.damage_sprites.push(Sprites::Reward.new(hero, expp)) if Imperial_Config::Show_Reward_Sprites
    else
      event.enemy.hp -= value
    end
    $game_map.damage_sprites.push(Sprites::Damage.new(event,value,weapon.color,critical)) if Imperial_Config::Show_Damage_Sprites
  end
  
  def all_actors
    result = []
    result.push($game_player)
    return result unless Imperial_Config::Followers::Enabled
    $game_player.followers.each {|follower| result.push(follower) }
    result.compact
  end
    
  def real_actors
    return [] if !$game_player.normal_walk?
    result = []
    result.push($game_player) if not $game_player.killed == true
    return result unless Imperial_Config::Followers::Enabled
    $game_player.followers.each {|follower|
      next if follower.killed
      result.push(follower)
    }
    result.compact
  end
  
  def real_enemies
    result = []
    $game_map.enemies.each {|enemy|
      next if enemy.killed
      next if enemy.enemy.nil?
      next if enemy.enemy.real_event
      next unless enemy.object.nil?
      result.push(enemy)
    }
    result.compact
  end
  
  def buff_cast!(target, buff)
    return if !buff.damage.recover? or !buff.for_friend?
    case target.class.to_s
    when 'Game_Event'
      actor = target.enemy
    when 'Game_Player'
      actor = $game_party.members[0]
    when 'Game_Follower'
      actor = $game_party.members[target.member_index]
    end
    return if actor.nil?
    target.minibar.nil? ? target.minibar = Sprites::Minibar.new(target) : target.minibar.restart
    if buff.damage.to_hp?
      if actor.hp == actor.mhp
        $game_map.damage_sprites.push(Sprites::Custom.new(target, "#{Vocab.hp_a} Full", Color.new(64,255,50)))
        return 
      end
      string = convert_formula_heal('actor', buff.damage.formula)
      value = eval(string)
      if actor.hp + value > actor.mhp
        $game_map.damage_sprites.push(Sprites::Heal.new(target, actor.mhp - actor.hp))
        actor.hp = actor.mhp
      else
        $game_map.damage_sprites.push(Sprites::Heal.new(target, value))
        actor.hp += value
      end
    elsif buff.damage.to_mp?
      if actor.mp == actor.mmp
        $game_map.damage_sprites.push(Custom_Sprite.new(target, "#{Vocab.mp_a} Full", Color.new(91,255,238)))
        return 
      end
      string = convert_formula_heal('actor', buff.damage.formula)
      value = eval(string)
      if actor.mp + value > actor.mmp
        $game_map.damage_sprites.push(Heal_Sprite.new(target, actor.mmp - actor.mp))
        actor.mp = actor.mmp
      else
        $game_map.damage_sprites.push(Heal_Sprite.new(target, value))
        actor.mp += value
      end
    end
    @animation_id = buff.animation_id
  end

  def hero_magical_damage(attacker, defender, skill, critical)
    return if skill.nil? or skill.damage.formula.empty?
    return if defender.killed or attacker.killed
    case defender.class.to_s
    when 'Game_Player'
      actor = $game_party.members[0]
    when 'Game_Follower'
      actor = $game_party.members[defender.member_index]
    end
    if !skill.effects.empty?
      skill.effects.each {|effect|
        next if effect.code != 21
        actor.add_state(effect.data_id)
      }
    end
    return if !skill.damage.to_hp?
    if attacker.object != nil
      temp = Imperial::Enemy.new(1)
      string = convert_formula_damage('temp', 'actor', skill.damage.formula)
    else
      string = convert_formula_damage('attacker.enemy', 'actor', skill.damage.formula)
    end
    print string,"\n"
    value = (eval(string) rescue 0)
    temp = nil
    value *= 3 if critical
    modifier = check_weakness(skill, defender)
    value *= modifier rescue value *= 1
    value -= actor.mdf
    value = 0 if value < 0
    type = check_type(modifier)
    defender.minibar.nil? ? defender.minibar = Sprites::Minibar.new(defender) : defender.minibar.restart
    $game_map.damage_sprites.push(Sprites::Magic.new(defender, value, critical, type))
    if actor.hp - value < 0
      case defender.class.to_s
      when 'Game_Player'
        hero = $game_player
        actor.hp = 0
        hero.perform_kill
        RPG::SE.new(Imperial_Config::PlayerDie_SE, 80).play
        last_actor_alive = $game_party.alive_members.size
        if last_actor_alive == 0
          $game_switches[Imperial_Config::Die_Switch] = true
          return
        end
        $game_party.swap_order(0, last_actor_alive, true)
        $game_player.followers.each {|follower|
          next if follower.member_index != last_actor_alive
          $game_player.moveto(follower.x, follower.y)
          $game_player.set_direction(follower.direction)
          follower.perform_kill
          follower.transparent = true
        }
      when 'Game_Follower'
        actor = $game_party.battle_members[defender.member_index]
        hero = defender
        actor.hp = 0
        hero.perform_kill
        RPG::SE.new(Imperial_Config::PlayerDie_SE, 80).play
        last_actor_alive = $game_party.alive_members.size
        if last_actor_alive == 0
          $game_switches[Imperial_Config::Die_Switch] = true
          return
        end
        $game_party.swap_order(hero.member_index, last_actor_alive, true)
      end
    else
      actor.hp -= value
    end
  end
  
  def check_weakness(item, defender)
    modifier = 1
    return modifier if item.nil? or defender.nil?
    return modifier if item.damage.nil?
    return modifier if item.damage.element_id.nil?
    return modifier if item.damage.element_id == (1 or 0)
    case defender.class.to_s
    when 'Game_Player'
      data = $game_party.members[0].actor
    when 'Game_Follower'
      data = ($game_party.members[denfender.member_index].actor rescue nil)
    when 'Game_Event'
      data = $data_enemies[defender.enemy.id]
    end
    return 1 if data.nil?
    data.features.each {|feature|
      next unless feature.code == 11
      if feature.data_id == item.damage.element_id
        modifier = feature.value
        break
      end
    }
    return modifier
  end
  
  def enemy_magical_damage(attacker, defender, skill, critical)
    return if defender.enemy.nil? and defender.object.nil?
    if defender.object != nil
      print "try start object \n"
      defender.try_start_object(skill)
      return
    end
    if !skill.effects.empty?
      skill.effects.each {|effect|
        print "effect ! \n"
        next if effect.code != 21
          print "adding state! \n"
          $game_map.damage_sprites.push(Sprites::Custom.new(defender, "Added State!"))
          defender.enemy.enemy.add_state(effect.data_id)
      }
    end
    return if !skill.damage.to_hp?
    if !defender.object.nil?
      if defender.object.only == nil
        start_object
      else
        if skill == defender.object.only; defender.start_object; else; defender.animation_id = 0; return; end
      end
      return
    end
    if defender.enemy.only != nil
      print "enemy only != nil"
      if defender.enemy.only != skill; defender.animation_id = 0; return; end
    end
    defender.minibar.nil? ? defender.minibar = Sprites::Minibar.new(defender) : defender.minibar.restart
    modifier = check_weakness(skill, defender)
    jump(0,0) if Imperial_Config::Jump_On_Damage
    case attacker.class.to_s
    when 'Game_Player'
      actor = $game_party.members[0]
    when 'Game_Follower'
      actor = $game_party.members[attacker.member_index]
    end
    string = convert_formula_damage('actor', 'defender.enemy', skill.damage.formula)
    print string,"\n"
    value = eval(string)
    value = 0 if value < 0
    value *= 3 if critical
    value *= modifier if not modifier.nil?
    #defender.enemy.minibar.nil? ? defender.enemy.minibar = Enemy_Minibar.new(self) : defender.enemy.minibar.restart
    type = check_type(modifier)
    $game_map.damage_sprites.push(Sprites::Magic.new(defender, value, critical, type))
    if defender.enemy.hp - value <= 0
      $game_map.enemies.delete(defender)
      defender.enemy.hp = 0
      defender.perform_kill
      Audio.se_play('Audio/Se/Blow6', 90, 100)
      expp = defender.enemy.enemy.exp
      actor.gain_exp(expp)
      $game_map.damage_sprites.push(Reward_Sprite.new(attacker, expp)) if Imperial_Config::Show_Reward_Sprites
    else
      defender.enemy.hp -= value
    end
  end
  
  def attakable_enemies
    result = []
    $game_map.enemies.each {|enemy|
      next if enemy.killed
      next if enemy.enemy.nil? and enemy.object.nil?
      result.push(enemy)
    }
    result.compact
  end
  
  def nearest_character(me, array)
    result = []
    return array if array.size == 1
    array.each {|char|
      dis = abs_distance_to(me, char)
      if result[dis].nil?
        result[dis] = char
      else
        result.push(char)
      end
    }
    result.compact
  end
  
  def check_enemy_id(command)
    result = command.parameters[0].downcase.clone
    result.sub!("enemy ",'')
    result = result.to_i
    if result.is_a?(Fixnum)
      return result
    else
      return 1
    end
  end
  
  class Not_Enemy
    
    attr_reader :exist
    
    def initialize
      @exist = true
    end
  end
  
  class Enemy
    
    attr_accessor :enemy; attr_accessor :id
    attr_accessor :hp;    attr_accessor :mp
    attr_accessor :mdef;  attr_accessor :animation
    attr_accessor :die;   attr_accessor :switch
    attr_accessor :only;  attr_accessor :minibar
    attr_accessor :stop;  attr_accessor :not_evade
    attr_accessor :follow;attr_accessor :real_event
    
    attr_reader :auto_attack
    attr_reader :weapon
    
    def initialize(id)
      @real_event = false
      @enemy = Game_Enemy.new(0, id.to_i)
      @die = 0; @id = id
      @hp = mhp; @mp = mmp
      @follow = Imperial_Config::Default_EnemyFollow
      note = $data_enemies[id].note
      if @auto_attack.nil?
        @auto_attack = (note.downcase == 'auto_attack')
      end
      if !note.empty?
        if note.downcase.include?('animation=')
          new = note.downcase; new.sub!('animation=','')
          @animation = new.to_i
        elsif note.downcase.include?('weapon=')
          new = note.downcase.clone; new.sub!("weapon=",'')
          new = new.to_i; new = 1 if new == 0
          @weapon = $data_weapons[new]
          @animation = @weapon.animation_id
        end
      else
        @animation = Imperial_Config::Default_Animation
      end
    end
      
    def mhp;  param(0);   end
    def mmp;  param(1);   end
    def def;  param(3);   end
    def mat;  param(4);   end
    def mdf;  param(5);   end
    def agi;  param(6);   end
    def luk;  param(7);   end
    def param(n); $data_enemies[id].params[n]; end
    def actions; $data_enemies[id].actions; end
      
    def atk
      if @weapon.nil?
        param(2)
      else
        param(2) + @weapon.params[2]
      end
    end
      
    def crit?
      rand = rand(100 + (agi + (agi/3))).to_i; lucky = rand(1) + 1
      return true if rand < agi + (lucky * luk) + 1
      return false
    end
    
    def evaded?
      if not_evade; not_evade = false; return false; end
      rand = rand(100 + (agi + (agi/3))).to_i; lucky = rand(2) + 1
      return true if rand < (agi / 2) + (lucky * luk) + luk * 0.5
      return false
    end
  end
  
  def check_object(command)
    result = command.parameters[0].downcase.clone
    result.sub(' ','') if result.include?(' ')
    return nil
  end
  
  class ABS_Object
    
    attr_accessor :switch
    attr_accessor :only
    attr_accessor :stop
    attr_accessor :auto_cast
    attr_accessor :breakable
    attr_accessor :hits
    
    def initialize(die_com, only = nil)
      @switch = die_com
      @only = only
      @auto_cast = nil
      @breakable = false
    end
  end
  
  def check_type(modifier)
    return 'none' if modifier.nil?
    return 'none' if modifier == 1
    if modifier > 1
      if modifier >= 5
        return 'monster'
      else
        return 'super'
      end
    elsif modifier < 1
      return 'less'
    end
  end
  
  class Drop < Sprite
    
    include Imperial_Config
    
    attr_accessor :character
    attr_reader :target
    attr_reader :gold
    attr_reader :count
    attr_reader :item
    
    def initialize(target, count, gold = false, item = nil)
      @target, @count, @gold, @item = target, count, gold, item
      @character = Game_Character.new
      @character.moveto(target.x, target.y)
      super(SceneManager.scene.spriteset.viewport1)
      if !gold
        index = (item.icon_index rescue nil)
        unless index == nil
          bitmap = Bitmap.new(24,24)
          bitmap.blt(0,0,Cache.system("Iconset"),Rect.new(index%16*24,index/16*24,24,24))
        end
      else
        bitmap = Bitmap.new(24,24)
        bitmap.blt(0,0,Cache.system("Iconset"),Rect.new(Gold_Icon_Index%16*24,Gold_Icon_Index/16*24,24,24))
      end
      self.bitmap = bitmap
      self.ox, self.oy = 0,0
      self.x = @character.screen_x - 13
      self.y = @character.screen_y - 18
      @item = item if item != nil
      @gold = gold
    end
    
    def update
      return if disposed?
      super; map = $game_map.clone
      self.x, self.y = @character.screen_x - 13, @character.screen_y - 18
      @near = check_player_near
      if @near == true
        pick_drop if Input.trigger?(Key::Enter)
      end
    end
      
    def pick_drop
      @gold ? $game_party.gain_gold(@item) : $game_party.gain_item(@item, 1)
      RPG::SE.new(Imperial_Config::PickUp_SE, 80).play rescue ''
      dispose
    end
    
    def check_player_near
      sx, sy = $game_player.screen_x - self.x, $game_player.screen_y - self.y
      return true if sx == x and sy == y
      case $game_player.direction
      when 2
        return true if sx.between?(0,32) and sy.between?(-32,20)
      when 4
        return true if sx.between?(0,64) and sy.between?(-18,32)
      when 6
        return true if sx.between?(-48,0) and sy.between?(-18,32)
      when 8
        return true if sx.between?(0,32) and sy.between?(0,64)
      end
      return false
    end
    
    def dispose
      @character = nil
      super
    end
  end
  
  class Pop < Window_Base
    
    def initialize(item, gold = false)
      if not item.nil?
        super(0,355,175,60)
        self.contents = Bitmap.new(width - 32, height - 32)
        self.z = 250
        if !gold
          self.contents.draw_text(30,5,120,20, item.name)
          draw_icon(item.icon_index, 5, 5)
        else
          self.contents.draw_text(30,5,120,20, "Gold + #{item}")
          draw_icon(Imperial_Config::Gold_Icon_Index, 5, 5)
        end
        @timer = 70
        self.opacity = 0; self.visible = false
      else
        dispose if not self.disposed?
      end
    end
    
    def update
      return if self.disposed?
      self.opacity = 255 if self.opacity != 255
      self.visible = true if self.visible == false
      @timer > 0 ? @timer -= 1 : dispose
    end
    
    def dispose
      super
    end
  end
end
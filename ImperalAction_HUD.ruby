#==============================================================================
# ** Imperial Action System I -- Heads-Up Display
#==============================================================================
# Autor: AndreMaker ou Maker-Leon ou Leon-S.K
#==============================================================================
#  Este é o script da HUD utilizada pelo Sistema, abaixo seguem as configurações
# da mesma.
#==============================================================================

module HUD_Config
  
  #--------------------------------------------------------------------------
  # * Configurações Gerais
  #--------------------------------------------------------------------------

  Switch = 2              # Switch que ativa/desativa a HUD
  
  Activate_Key = Key::F   # Tecla que controla a switch
  
  Base_Bar = 'bars-base'  # Grafico da base da HUD
  HP_Bar  = 'hp_bar'      # Grafico da barra de HP
  MP_Bar  = 'mp_bar'      # Grafico da barra de MP

  # Coordenadas X e Y da barra de HP
  HP_X = 66    
  HP_Y = 29
  
  # Coordenadas X e Y da barra de MP
  MP_X = 66
  MP_Y = 39
  
  # TEXTO
  Text_Size = 14        # Tamanho  
  Text_Color = Color.new(255,216,0)   # Cor => Color.new(red, green, blue)
  Text_Bold = true      # Negrito? (true/false)
  Alingment = 1         # Alinhamento: Esquerda 0, Centrado 1 e Direita 2
  
  # Coordenadas X e Y do Nome
  Name_X = 67
  Name_Y = 13
  # Largura e Altura do nome (respectivamente)
  Name_Width = 104
  Name_Height = 14
  
  # Coordenadas X e Y do LVL
  LV_X = 11
  LV_Y = 46
  # Largura e Altura do LVL (respectivamente)
  LV_Width = 17
  LV_Height = 14
  
  # Coordenadas X e Y das FACES
  DF_X = 9
  DF_Y = 3
  
  # Grafico padrão de Faces
  D_Face = "default_face"
  
  #--------------------------------------------------------------------------
  # * Faces próprias para o player
  #--------------------------------------------------------------------------
                          Custom_Faces = {}
  
  # Custom_Faces[ID] = [nome do grafico, x, y]
  Custom_Faces[18] = ["rasante_face", 9, 3]
  Custom_Faces[19] = ["tk_face", 9, 3]
  Custom_Faces[20] = ["liza_face", 9, 3]
  Custom_Faces[21] = ["willie_face", 9, 3]
  

#==============================================================================

  module Action_Bars
    
    #--------------------------------------------------------------------------
    # * Configurações de Skills, Items e Buffs
    #--------------------------------------------------------------------------
    
    Visible = true          # Visiveis? (true/false)
    
    Base = "action_bars"    # Grafico Base
    Base_X = 425            # Coord X
    Base_Y = 0              # Coord Y
    
    Skill_X = 435           # Coord X do icone da skill selecionada
    Skill_Y = 23            # Coord Y do icone da skill selecionada
    
    Buff_X = 473            # Coord X do icone do buff selecionada
    Buff_Y = 23             # Coord Y do icone do buff selecionada
    
    Item_X = 510            # Coord X do icone do item selecionada
    Item_Y = 23             # Coord Y do icone do item selecionada
    
  end
  
#==============================================================================

  module Stance
    
    #--------------------------------------------------------------------------
    # * Configurações de Stance dos Followers
    #--------------------------------------------------------------------------
    
    Visible = true          # Visiveis? (true/false)
    
    Attack = 131      # Index do icone de atacando
    
    Defend = 139      # Index do icone de defendendo
    
    # Coordenadas X e Y do icone
    Icon_X = 41
    Icon_Y = 39
    
  end
  
#==============================================================================
end

#===============================================================================
#  FIM DAS CONFIGURAÇÕES
#===============================================================================

#==============================================================================
class Hud < Sprite
  
  include HUD_Config
  
  attr_accessor :hp
  attr_accessor :mp
  attr_accessor :slc_item
  attr_accessor :slc_skill
  attr_accessor :slc_buff
  
  def initialize
    super()
    self.bitmap = Bitmap.new(544, 416)
    @base = Cache.system(Base_Bar)
    @hp_bit = Cache.system(HP_Bar)
    @mp_bit = Cache.system(MP_Bar)
    @level = $game_party.members[0].level 
    @name = $game_party.members[0].name
    self.bitmap.blt(0,0, @base, Rect.new(0,0,@base.width, @base.height))
    self.bitmap.blt(HP_X,HP_Y, @hp_bit, Rect.new(0,0,@hp_bit.width, @hp_bit.height))
    self.bitmap.blt(MP_X,MP_Y, @mp_bit, Rect.new(0,0,@mp_bit.width, @mp_bit.height))
    self.bitmap.font.color = Text_Color; self.bitmap.font.size = Text_Size; self.bitmap.font.bold = Text_Bold
    self.bitmap.draw_text(Name_X,Name_Y,Name_Width,Name_Height,@name, Alingment)
    self.bitmap.draw_text(LV_X,LV_Y,LV_Width,LV_Height,@level, Alingment)
    refresh
  end
  
  def refresh
    actor = $game_party.members[0]
    self.bitmap.clear
    @name, @level = actor.name, actor.level
    @wd = @hp_bit.width * actor.hp / actor.mhp
    @md = @mp_bit.width * actor.mp / actor.mmp
    @slc_item = $game_player.selected_item
    @slc_skill = $game_player.selected_skill
    @slc_buff = $game_player.selected_buff
    draw_face
    draw_bars
    draw_action_bars if Action_Bars::Visible
    draw_stance if Stance::Visible
    $game_system.hud_need_refresh = false
  end
  
  def draw_stance
    case $game_player.stance
    when :attack
      self.bitmap.blt(Stance::Icon_X, Stance::Icon_Y, Cache.system('Iconset'), Rect.new(Stance::Attack%16*24,Stance::Attack/16*24,24,24))
    when :defend
      self.bitmap.blt(Stance::Icon_X, Stance::Icon_Y, Cache.system('Iconset'), Rect.new(Stance::Defend%16*24,Stance::Defend/16*24,24,24))
    end
  end

  def draw_bars
    actor = $game_party.members[0]
    self.bitmap.blt(0,0, @base, Rect.new(0,0,@base.width, @base.height))
    self.bitmap.blt(HP_X,HP_Y, @hp_bit, Rect.new(0,0,@wd, @hp_bit.height))
    self.bitmap.blt(MP_X,MP_Y, @mp_bit, Rect.new(0,0,@md, @mp_bit.height))
    self.bitmap.font.color = Text_Color; self.bitmap.font.size = Text_Size; self.bitmap.font.bold = Text_Bold
    self.bitmap.draw_text(Name_X,Name_Y,Name_Width,Name_Height,@name, Alingment)
    self.bitmap.draw_text(LV_X,LV_Y,LV_Width,LV_Height,@level, Alingment)
  end
  
  def draw_face
    actor = $game_party.members[0]
    if Custom_Faces.keys.include?(actor.id)
      array = Custom_Faces[actor.id]
      bitmap = Cache.face(array[0])
      self.bitmap.blt(array[1], array[2], bitmap, Rect.new(0,0,bitmap.width, bitmap.height))
    else
      bitmap = Cache.face(D_Face)
      self.bitmap.blt(DF_X, DF_Y, bitmap, Rect.new(0,0,bitmap.width, bitmap.height))
    end
  end
  
  def draw_action_bars
    bitmap = Cache.system(Action_Bars::Base)
    self.bitmap.blt(Action_Bars::Base_X, Action_Bars::Base_Y, bitmap, Rect.new(0,0,bitmap.width, bitmap.height))
    if not @slc_skill.nil?
      index = @slc_skill.icon_index
      self.bitmap.blt(Action_Bars::Skill_X, Action_Bars::Skill_Y, Cache.system('Iconset'), Rect.new(index%16*24,index/16*24,24,24))
    end
    if not @slc_buff.nil?
      index = @slc_buff.icon_index
      self.bitmap.blt(Action_Bars::Buff_X, Action_Bars::Buff_Y, Cache.system('Iconset'), Rect.new(index%16*24,index/16*24,24,24))
    end
    if not @slc_item.nil?
      index = @slc_item.icon_index
      self.bitmap.blt(Action_Bars::Item_X, Action_Bars::Item_Y, Cache.system('Iconset'), Rect.new(index%16*24,index/16*24,24,24))
      x, y, number = Action_Bars::Item_X, Action_Bars::Item_Y, $game_party.item_number(@slc_item)
      self.bitmap.draw_text(x + 5,y + 9,70,35, "x#{number.to_s}")
    end
  end
  
  def p_width
    @base.width
  end
  
  def p_height
    @base.height
  end
  
  def ww
    bitmap = Cache.system(Action_Bars::Base)
    return Action_Bars::Base_X, Action_Bars::Base_X + bitmap.width
  end
  
  def hh
    bitmap = Cache.system(Action_Bars::Base)
    return Action_Bars::Base_Y, Action_Bars::Base_Y + bitmap.height
  end
  
  def dispose
    super
  end
end

class Scene_Map < Scene_Base
  
  include HUD_Config
      
  alias hud_start start
  alias hud_terminate terminate
  alias hud_update update
  
  def start
    hud_start
    if $game_switches[Switch] == true
      @hud = Hud.new
    end
  end
  
  def update
    hud_update
    if Input.trigger?(Activate_Key)
      $game_switches[Switch] = ($game_switches[Switch] ? false : true)
    end
    if $game_switches[Switch] == true
      @hud.nil? ? @hud = Hud.new : refresh_hud
    else
      if not @hud.nil?; @hud.dispose; @hud = nil; end
    end
  end
  
  def refresh_hud
    @hud.refresh if $game_party.members[0].hp != @hud.hp or $game_party.members[0].mp != @hud.mp
    @hud.refresh if $game_player.selected_skill != @hud.slc_skill or $game_player.selected_buff != @hud.slc_buff
    @hud.refresh if $game_system.hud_need_refresh
    @hud.z = 500 if !$game_map.windows.empty?
    down = false
    if $game_player.screen_x <= @hud.p_width and $game_player.screen_y <= @hud.p_height
      @hud.opacity = 100 if @hud.opacity != 100
    else
      if Action_Bars::Visible
        x1, y1 = @hud.ww
        x2, y2 = @hud.hh
        if $game_player.screen_x.between?(x1,y1) and $game_player.screen_y.between?(x2 + 10,y2 + 10)
          @hud.opacity = 100 if @hud.opacity != 100
        else
          @hud.opacity = 255 if @hud.opacity != 255
        end
      else
        @hud.opacity = 255 if @hud.opacity != 255
      end
    end
  end
  
  def terminate
    if @hud != nil; @hud.dispose if not @hud.disposed?; end
    hud_terminate
  end
  
  def hide_hud
    return if @hud.nil?
    return if @hud.disposed?
    @hud.visible ? @hud.visible = false : @hud.visible = true
  end
end

class Game_System; attr_accessor :hud_need_refresh; end
  
class Scene_Map; attr_reader :spriteset; end

class Spriteset_Map
  
  include Imperial
  include Imperial_Config
  
  attr_reader :viewport1
  
  alias mp_initialize initialize
  alias mp_update update
  alias mp_dispose dispose
  
  def update_minibars_disposing
    all_actors.each {|actor|
      next if actor.minibar.nil?
      if actor.killed
        actor.minibar.dispose if not actor.minibar.disposed?
        actor.minibar = nil
      end
    }
    $game_map.enemies.each {|enemy|
      next if enemy.minibar.nil?
      if enemy.enemy.nil?
        enemy.minibar.dispose if not enemy.minibar.disposed?
        enemy.minibar = nil
      else
        if enemy.enemy.hp <= 0 or enemy.killed
          enemy.minibar.dispose if not enemy.minibar.disposed?
          enemy.minibar = nil
        end
      end
    }
  end
  
  def initialize
    @hero_weapons = {}
    @enemy_weapons = {}
    @secondary_weapons = {}
    mp_initialize
    @shield_sprite = Sprite.new(@viewport1)
    @shield_sprite.ox, @shield_sprite.oy = 22, 22
    refresh_shield
  end
  
  def refresh_shield
    return if $game_party.members[0].equips[1].nil?
    @bitmap = Bitmap.new(24,24)
    icon = $game_party.members[0].equips[1].icon_index
    return if icon.nil?
    @bitmap.blt(0,0,Cache.system("Iconset"),Rect.new(icon%16*24,icon/16*24,24,24))
  end
  
  def update
    mp_update
    map = $game_map
    update_minibars_disposing
    trash = []
    map.damage_sprites.each {|sprite|
      sprite.update
      trash.push(sprite) if sprite.disposed?
    }
    trash.each {|item| map.damage_sprites.delete(item) }
    map.damage_sprites.compact!
    @enemy_weapons = {} if @enemy_weapons.nil?
    map.drops.each { |drop|
      drop.update
      trash.push(drop) if drop.disposed?
    }
    trash.each {|item| map.drops.delete(item)}; trash.clear
    if !$game_map.windows.empty?
      if $game_map.windows[0].is_a?(Pop)
        $game_map.windows[0].update
        trash.push($game_map.windows[0]) if $game_map.windows[0].disposed?
      end
    end
    trash.each { |item| $game_map.windows.delete(item) }; trash.clear
    $game_map.windows.compact!
    otherss = []; no_need = []
    map.characters.each { |char| otherss.push(char) if char.is_a?(Ranged::Enemy_Skill) }
    otherss.each {|char| no_need.push(char) if !map.enemies.include?(char.enemy)}
    otherss.clear; no_need.each {|char| map.characters.delete(char)}; no_need.clear
    map.characters.each { |char|
      char.sprite = Sprite_Character.new(@viewport1, char) if char.sprite.nil? 
      char.update; trash.push(char) if char.disposed? }
    trash.each { |item| $game_map.characters.delete(item) }; trash.clear
    # Weapon Sprites
    update_hero_weapons if !@hero_weapons.empty?
    update_enemy_weapons if !@enemy_weapons.empty?
    update_secondary_weapons if !@secondary_weapons.empty?
    if $game_player.shielding
      update_shielding
    else
      if @shield_sprite
        @shield_sprite.bitmap = nil if @shield_sprite.bitmap != nil
      end
    end
  end
  
  def update_shielding
    refresh_shield if @bitmap.nil?
    return if @bitmap.nil?
    @shield_sprite.bitmap = @bitmap if @shield_sprite.bitmap.nil?
    @shield_sprite.x = $game_player.screen_x + Shield_correction[$game_player.direction][0]
    @shield_sprite.y = $game_player.screen_y + Shield_correction[$game_player.direction][1]
    @shield_sprite.angle = Shield_angles[$game_player.direction]
    @shield_sprite.z = Shield_z[$game_player.direction]
  end
  
  def dispose
    $game_map.last_drops = $game_map.drops
    $game_map.characters.each {|char| char.sprite.dispose if not char.sprite.disposed?; char.sprite = nil}
    $game_map.damage_sprites.each { |sprite| sprite.dispose if not sprite.disposed?}
    $game_map.windows.each { |sprite| sprite.dispose if not sprite.disposed? }
    $game_map.damage_sprites.clear; $game_map.windows.clear
    @hero_weapons.each {|array|
      next if array[1][0].nil?
      array[1][0].dispose if not array[1][0].disposed?
    }
    @hero_weapons = nil
    @enemy_weapons.each {|array|
      next if array[1][0].nil?
      array[1][0].dispose if not array[1][0].disposed?
    }
    @enemy_weapons = nil
    @shield_sprite.dispose if not @shield_sprite.disposed?
    if $game_player.minibar != nil
      $game_player.minibar.dispose if not $game_player.minibar.disposed?
      $game_player.minibar = nil
    end
    $game_map.enemies.each {|enemy|
      next if enemy.minibar.nil?
      enemy.minibar.dispose if not enemy.minibar.disposed?
      enemy.minibar = nil
    }
    $game_player.followers.each {|f|
      next if f.minibar.nil?
      f.minibar.dispose if not f.minibar.disposed?
      f.minibar = nil
    }
    mp_dispose
  end
  
  def hero_attack(hero, weapon, ranged = false)
    return if hero.nil?
    return if !weapon.is_a?(RPG::Weapon)
    icon = (weapon.icon_index rescue nil)
    if !icon.nil?
      bitmap = Bitmap.new(24,24)
      bitmap.blt(0,0,Cache.system("Iconset"),Rect.new(icon%16*24,icon/16*24,24,24))
      sprite = Sprite.new(@viewport1)
      sprite.ox, sprite.oy = 22,22
      sprite.bitmap = bitmap
      @hero_weapons[hero] = [sprite,true,12,ranged]
    end
  end
  
  def enemy_attack(event, weapon, ranged = false)
    return if event.nil?
    return if event.enemy.nil?
    return if !weapon.is_a?(RPG::Weapon)
    icon = (weapon.icon_index rescue nil)
    if !icon.nil?
      bitmap = Bitmap.new(24,24)
      bitmap.blt(0,0,Cache.system("Iconset"),Rect.new(icon%16*24,icon/16*24,24,24))
      sprite = Sprite.new(@viewport1)
      sprite.ox, sprite.oy = 22,22
      sprite.bitmap = bitmap
      @enemy_weapons[event] = [sprite,true,12,ranged]
    end
  end
  
  def update_hero_weapons
    trash = []
    @hero_weapons.each_with_index {|array, i|
      update_array_weapon(array)
      trash.push(@hero_weapons[i]) if array[1][1] == false
    }
    trash.each {|item| @hero_weapons.delete(item) }; trash.clear
  end
  
  def update_enemy_weapons
    trash = []
    @enemy_weapons.each_with_index {|array, i|
      update_array_weapon(array)
      trash.push(@enemy_weapons[i]) if array[1][1] == false
    }
    trash.each {|item| @enemy_weapons.delete(item) }; trash.clear
  end
  
  def update_secondary_weapons
    
  end
  
  def update_array_weapon(array)
    array[1][0].x = array[0].screen_x + Move_correction[array[0].direction][0]
    array[1][0].y = array[0].screen_y + Move_correction[array[0].direction][1]
    if array[1][0].zoom_x != Weapon_Sprites_Zoom
      array[1][0].zoom_x = Weapon_Sprites_Zoom
      array[1][0].zoom_y = Weapon_Sprites_Zoom
    end
    if !array[1][3]
      case array[1][2]
      when 12
        array[1][0].angle = Sprite_angles[array[0].direction][0]
        array[1][0].z = Sprite_z_values[array[0].direction] - 15
      when 9
        array[1][0].angle = Sprite_angles[array[0].direction][1]
        array[1][0].z = Sprite_z_values[array[0].direction] - 15
      when 6
        array[1][0].angle = Sprite_angles[array[0].direction][2]
        array[1][0].z = Sprite_z_values[array[0].direction] - 15
      when 3
        array[1][0].angle = Sprite_angles[array[0].direction][3]
        array[1][0].z = Sprite_z_values[array[0].direction] - 15
      when 0
        array[1][1] = false
        array[1][0].bitmap = nil
      end
    else
      if array[1][2] > 0
        array[1][0].angle = Sprite_angles[array[0].direction][2]
        array[1][0].z = Sprite_z_values[array[0].direction] - 15
      else
        array[1][1] = false
        array[1][0].bitmap = nil
      end
    end
    array[1][0].update
    array[1][2] -= 1
  end
end

class Game_Map
  
  attr_accessor :enemies
  attr_accessor :damage_sprites
  attr_accessor :characters
  attr_accessor :drops
  attr_accessor :windows
  attr_accessor :last_drops
  
  alias mp_setup setup
  
  def setup(map_id)
    @enemies.nil? ? @enemies = [] : @enemies.clear
    @damage_sprites.nil? ? @damage_sprites = [] : @damage_sprites.clear
    @windows.nil? ? @windows = [] : @windows.clear
    @characters.nil? ? @characters = [] : @characters.clear
    @drops.nil? ? @drops = [] : @drops.clear
    @last_drops.nil? ? @last_drops = [] : @last_drops.clear
    mp_setup(map_id)
  end
end

class << DataManager

  alias color_init load_normal_database
  
  def load_normal_database
    color_init
    $data_weapons.each { |w| next if w.nil?; w.get_color }
    $data_skills.each {|s| next if s.nil?; s.get_color}
  end
end
  
module RPG
  
  class Weapon
    
    attr_accessor :color
    
    def get_color
      if self.note.include?("hit_color=")
        @color = eval("Color.new(#{note.sub("hit_color=","")})")
      else
        @color = Color.new(255,255,255)
      end
    end
  end
  
  class Skill
    
    attr_accessor :color
    
    def get_color
      if self.note.include?("hit_color=")
        @color = eval("Color.new(#{note.sub("hit_color=","")})")
      else
        @color = Color.new(210,33,255)
      end
    end
  end
end
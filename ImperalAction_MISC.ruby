#==============================================================================
# ** Imperial Action System I -- Misc.
#==============================================================================
# Autor: AndreMaker ou Maker-Leon ou Leon-S.K
#==============================================================================
#  Este script contem algumas definições de efeitos visuais, entre outros...
# É recomendavel não mecher, e por favor nao copie... Obrigado =]
#==============================================================================

module Sprites
  
  class Damage < Sprite
  
    def initialize(target, value, color, crit = false)
      super(nil)
      @target = target
      if color.is_a?(TrueClass) or color.is_a?(FalseClass)
        crit = color
        color = Color.new(255,255,255)
      end
      if crit
        self.bitmap = Bitmap.new(120,40)
        self.bitmap.font.size = self.bitmap.font.size + 4
        self.bitmap.font.color = Color.new(255,106,0)
        self.bitmap.draw_text(0,0,120,40,"Crit! #{value}",1)
      else
        self.bitmap = Bitmap.new(100,20)
        self.bitmap.font.color = color
        self.bitmap.draw_text(0,0,100,20,value,1)
      end
      self.ox = 50
      self.z = 999
      self.x = target.screen_x
      self.y = target.screen_y - 40
      @minus = 40
      crit ? @timer = 70 : @timer = 50
    end
    
    def update
      return if self.disposed?
      self.x = @target.screen_x
      self.y = @target.screen_y - @minus
      if @timer > 0
        @timer -= 1
        @minus += 1 if not @minus >= 60
      else
        if self.opacity > 0
          self.opacity -= 15
          self.y -= 2
        else
          dispose
        end
      end
    end
  end
  
  class Heal < Sprite
    
    def initialize(target, value)
      super(nil)
      @target = target
      self.bitmap = Bitmap.new(100,20)
      self.bitmap.font.color = Color.new(76,255,255)
      self.bitmap.draw_text(0,0,100,20,"+ #{value}",1)
      self.ox = 50
      self.z = 999
      self.x = target.screen_x
      self.y = target.screen_y - 40
      @timer = 50
    end
    
    def update
      if @timer > 0
        @timer -= 1
        self.y -= 1 if not self.y < @target.screen_y - 60
      else
        if self.opacity > 0
          self.opacity -= 15
          self.y -= 2
        else
          dispose
        end
      end
    end
    
    def dispose
      self.bitmap.dispose
      super
    end
  end
  
  class Magic < Sprite
    
    def initialize(target, value, crit = false, type = 'none')
      super(nil)
      @target = target; value = value.to_i
      self.bitmap = Bitmap.new(120,40)
      #self.bitmap.font.color = color
      case type
      when 'none'
        if crit
          self.bitmap.font.size = self.bitmap.font.size + 4
          self.bitmap.font.color = Color.new(60,21,76)
          self.bitmap.draw_text(0,0,120,40,"Crit! #{value}",1)
        else
          self.bitmap.font.color = Color.new(210,33,255)
          self.bitmap.draw_text(0,0,100,20,value,1)
        end
      when 'super'
        self.bitmap.font.size = self.bitmap.font.size + 2
        if crit
          self.bitmap.font.size = self.bitmap.font.size + 4
          self.bitmap.font.color = Color.new(127,51,0)
          self.bitmap.draw_text(0,0,120,40,"Crit! #{value}",1)
        else
          self.bitmap.font.color = Color.new(255,123,0)
          self.bitmap.draw_text(0,0,100,20,value,1)
        end
      when 'less'
        if crit
          self.bitmap.font.size = self.bitmap.font.size + 4
          self.bitmap.font.color = Color.new(109,109,255)
          self.bitmap.draw_text(0,0,120,40,"Crit! #{value}",1)
        else
          self.bitmap.font.color = Color.new(178,179,255)
          self.bitmap.draw_text(0,0,100,20,value,1)
        end
       when 'monster'
        if crit
          self.bitmap.font.size = self.bitmap.font.size + 4
          self.bitmap.font.color = Color.new(127,51,0)
          self.bitmap.draw_text(0,0,120,40,"Crit!!#{value}!!",1)
        else
          self.bitmap.font.size = self.bitmap.font.size + 4
          self.bitmap.font.color = Color.new(127,51,0)
          self.bitmap.draw_text(0,0,100,40,"!!#{value}!!",1)
        end
     end
      self.ox = 50
      self.z = 999
      self.x = target.screen_x
      self.y = target.screen_y - 40
      if not type = 'monster'
        crit ? @timer = 70 : @timer = 50
      else
        crit ? @timer = 100 : @timer = 70
      end
    end
    
    def update
      if @timer > 0
        @timer -= 1
        self.y -= 1 if not self.y < @target.screen_y - 60
      else
        if self.opacity > 0
          self.opacity -= 15
          self.y -= 2
        else
          dispose
        end
      end
    end
    
    def dispose
      self.bitmap.dispose
      super
    end
  end
  
  class Drain < Sprite
    
  end
  
  class Custom < Sprite
    
    attr_reader :text
    attr_reader :target
    
    def initialize(target, value, color = Color.new(72,0,255), timer = 50)
      super(nil)
      @target = target
      @text = value.to_s
      self.bitmap = Bitmap.new(100,20)
      if color.nil?
        self.bitmap.font.color = Color.new(72,0,255)
      else
        self.bitmap.font.color = color
      end
      self.bitmap.draw_text(0,0,100,20,value,1)
      self.ox = 50
      self.z = 999
      self.x = target.screen_x
      self.y = target.screen_y - 40
      @timer = timer; @qnt = 40
    end
    
    def update
      if @timer > 0
        self.x = @target.screen_x
        self.y = @target.screen_y - @qnt
        @timer -= 1
        @qnt += 1 if not self.y < @target.screen_y - 60
      else
        if self.opacity > 0
          self.opacity -= 15
          self.y -= 2
        else
          dispose
        end
      end
    end
  end
  
  class Minibar < Sprite
    def initialize(target, time = 60)
      @target = target
      case target.class.to_s
      when "Game_Event"
        @actor = target.enemy
      when "Game_Player"
        @actor = $game_party.battle_members[0]
      when "Game_Follower"
        @actor = $game_party.battle_members[target.member_index]
      end
      super()
      self.bitmap = Bitmap.new(37,6)
      self.x = target.screen_x - 18
      self.y = target.screen_y
      self.viewport = SceneManager.scene.spriteset.viewport1 if SceneManager.scene.is_a?(Scene_Map)
      self.z = 20
      # Base
      self.bitmap.fill_rect(0,0,37,6,Color.new(0,0,0))
      #HP
      if target.nil?
        dispose; return
      end
      if @actor.nil?
        dispose; return
      end
      hw = 37 * @actor.hp/@actor.mhp
      self.bitmap.fill_rect(0,0,hw,3,Color.new(0,255,33))
      #MP
      if not @actor.mmp <= 0
        mw = 37 * @actor.mp/@actor.mmp
        self.bitmap.fill_rect(0,3,mw,3,Color.new(0,38,255))
      end
      @timer = time
    end
    
    def update
      return if disposed?
      if @actor.nil?
        dispose; return
      else
        if @actor.hp <= 0
          @timer = 0
          dispose;return
        end
      end
      self.x = @target.screen_x - 18
      self.y = @target.screen_y
      # Base
      self.bitmap.fill_rect(0,0,37,6,Color.new(0,0,0))
      #HP
      hw = 37 * @actor.hp/@actor.mhp
      self.bitmap.fill_rect(0,0,hw,3,Color.new(0,255,33))
      #MP
      if not @actor.mmp <= 0
        mw = 37 * @actor.mp/@actor.mmp
        self.bitmap.fill_rect(0,3,mw,3,Color.new(0,38,255))
      end
      if not Imperial_Config::Minibar_Always
        if @timer > 0
          @timer -= 1
        else
          self.opacity > 0 ? self.opacity -= 20 : dispose
        end
      end
    end
    
    def restart(time = 60)
      return if disposed?
      self.bitmap.clear; self.opacity = 255
      self.x = @target.screen_x - 18
      self.y = @target.screen_y
      # Base
      self.bitmap.fill_rect(0,0,37,6,Color.new(0,0,0))
      #HP
      hw = 37 * @actor.hp/@actor.mhp
      self.bitmap.fill_rect(0,0,hw,3,Color.new(0,255,33))
      #MP
      if not @actor.mmp <= 0
        mw = 37 * @actor.mp/@actor.mmp
        self.bitmap.fill_rect(0,3,mw,3,Color.new(0,38,255))
      end
      @timer = time
    end
  end
end

module Ranged
  
  class Enemy_Skill < Game_Character
    
    include Imperial
    
    attr_accessor :sprite
    attr_accessor :skill
    attr_reader :enemy
    
    def initialize(vel, range, char_name, char_index, skill, enemy)
      super()
      @enemy = enemy
      @hero = nil
      moveto(@enemy.x, @enemy.y)
      @through = true
      @character_name = char_name; @character_index = char_index
      vel = 9 if vel > 9
      @move_speed = vel
      @move_frequency = 3
      @range = range
      @priority_type = 1
      @skill = skill
      @timer = 0
      @disposed = false; @next_update = false
      set_direction(@enemy.direction)
    end
    
    def update
      return if disposed?
      super
      @sprite.update if !@sprite.disposed?
      if @conflicted
        conflict_dispose
        return
      end
      if @enemy.object.nil?
        if @enemy.enemy.hp <= 0
          dispose
          return
        end
      else
        if @enemy.object.nil?
          dispose
          return
        end
      end
      if @range == 0; dispose; return; end
      super
      @sprite.update if !@sprite.disposed?
      move_straight(direction) if !moving? and @range > 0
      activate(check_enemy_trigger)
    end
      
    def on_next_update(hero)
      if x == hero.x and y == hero.y
        dispose
        @next_update = false
        @hero = nil
      end
    end
    
    def move_straight(d, turn_ok = true)
      super(d, turn_ok = true)
      @through = false
      @range -= 1 if not @range == 0
    end
    
    def conflict_dispose
      return if disposed?
      @conflicted = true if not @conflicted
      @character_name = '' if @character_name != ''
      @charcter_index = 0 if @character_index != 0
      if not @animation_id.nil? or @animation_id == 0
        dispose if !disposed? and $data_animations[@animation_id].nil?
        return if disposed?
        @timer = $data_animations[@animation_id].frames.size * 2 if @timer == 0
      end
      @timer > 0 ? @timer -= 1 : dispose
    end
    
    def activate(hero)
      return if hero.is_a?(FalseClass)
      hero.animation_id = @skill.animation_id
      hero_magical_damage(@enemy, hero, @skill, false); @trought = true
      #@waiting = true
      dispose
    end
    
    def check_enemy_trigger
      real_actors.each {|char|
        return char if char.x == @x and char.y == @y
      }
      return false
    end
    
    def dispose
      return if disposed?
      @on_next_update = false
      @character_name = ''; @character_index = 0
      moveto(0,0)
      @sprite.dispose if not @sprite.disposed?
      @disposed = true
    end
    
    def disposed?
      @disposed
    end
  end
  
  class Hero_Skill < Game_Character
    
    include Imperial
    attr_accessor :sprite
    
    def initialize(vel, range, char_name, char_index, skill, caster)
      super()
      @caster = caster; @skill = skill; @range = range
      moveto(@caster.x, @caster.y)
      @character_name = char_name; @character_index = char_index
      set_direction(@caster.direction)
      vel = 9 if vel > 9
      @move_speed = vel
      @move_frequency = 3
      @timer = 0
      @priority_type = 1
      @disposed = false
    end
    
    def update
      return if disposed?
      super
      @sprite.update if !@sprite.disposed?
      if @waiting
        if @target.x == x and @target.y == y
          @waiting = false; @target = nil
          dispose
        else
          move_straight(direction)
        end
      end
      if @conflicted
        conflict_dispose
        return
      end
      if @range == 0; dispose; return; end
      super
      @sprite.update if !@sprite.disposed?
      move_straight(direction) if !moving? and @range > 0
      conflict(check_conflict_trigger)
      activate(check_enemy_trigger)
    end
    
    def passable?(x, y, d)
      x2 = $game_map.round_x_with_direction(x, d)
      y2 = $game_map.round_y_with_direction(y, d)
      return true if $game_map.counter?(x2, y2)
      return false unless $game_map.valid?(x2, y2)
      return true if @through || debug_through?
      return false unless map_passable?(x, y, d)
      return false unless map_passable?(x2, y2, reverse_dir(d))
      return false if collide_with_characters?(x2, y2)
      return true
    end
    
    def conflict(char)
      return if char.is_a?(FalseClass)
      my_skill = @skill
      his_skill = char.skill
      r = rand(2) + 1
      if my_skill.mp_cost > his_skill.mp_cost
        index = $game_map.characters.index(char)
        $game_map.characters[index].animation_id = @skill.animation_id
        $game_map.characters[index].conflict_dispose
        return
      elsif my_skill.mp_cost == his_skill.mp_cost
        index = $game_map.characters.index(char)
        his_animation =  $game_map.characters[index].skill.animation_id
        $game_map.characters[index].animation_id = @skill.animation_id
        $game_map.characters[index].conflict_dispose
        @animation_id = his_animation
        conflict_dispose
      else
        index = $game_map.characters.index(char)
        his_animation =  $game_map.characters[index].skill.animation_id
        @animation_id = his_animation
        conflict_dispose
      end
    end
    
    def conflict_dispose
      return if disposed?
      @conflicted = true if not @conflicted
      @character_name = '' if @character_name != ''
      @charcter_index = 0 if @character_index != 0
      if not @animation_id.nil? or @animation_id == 0
        dispose if !disposed? and $data_animations[@animation_id].nil?
        return if disposed?
        @timer = $data_animations[@animation_id].frames.size * 3 if @timer == 0
      end
      @timer > 0 ? @timer -= 1 : dispose
    end
    
    def check_conflict_trigger
      chars = []
      $game_map.characters.each { |char| chars.push(char) if char.is_a?(Ranged::Enemy_Skill) }
      chars.each {|enemy| return enemy if distance_to(self, enemy) <= 1 and @range - 1 > 0}
      return false
    end
    
    def move_straight(d, turn_ok = true)
      super(d, turn_ok)
      @range -= 1 if not @range == 0
    end
    
    def activate(enemy)
      return if enemy.is_a?(FalseClass)
      return if @waiting
      @trought = true
      enemy.animation_id = @skill.animation_id
      enemy_magical_damage(@caster, enemy, @skill, false)
      move_straight(direction)
      @waiting = true; @target = enemy
      #dispose
    end
    
    def check_enemy_trigger
      $game_map.enemies.compact!
      case direction
      when 2
        attakable_enemies.each {|enemy|t(enemy); return enemy if enemy.x == x and (enemy.y == y + 1 or enemy.y == y) and @range - 1 > 0}
      when 4
        attakable_enemies.each {|enemy|t(enemy); return enemy if (enemy.x == x - 1 or enemy.x == x) and enemy.y == y and @range - 1 > 0}
      when 6
        attakable_enemies.each {|enemy|t(enemy); return enemy if (enemy.x == x + 1 or enemy.x == x) and enemy.y == y and @range - 1 > 0}
      when 8
        attakable_enemies.each {|enemy|t(enemy); return enemy if enemy.x == x and (enemy.y == y - 1 or enemy.y == y) and @range - 1 > 0}
      end
      return false
    end
    
    def t(enemy)
      @through = true if distance_to(self, enemy).abs <= 1
    end
    
    def dispose
      return if disposed?
      @on_next_update = false
      moveto(0,0)
      @character_name = ''; @character_index = 0
      @sprite.dispose if not @sprite.disposed?
      @disposed = true
    end
    
    def disposed?
      @disposed
    end
  end
  
  class Enemy_Ranged < Game_Character
    
    include Imperial
    
  end
  
  class Hero_Ranged < Game_Character
    
    include Imperial
    attr_accessor :sprite
    
    def initialize(vel, range, char_name, char_index, weapon, caster)
      super()
      @caster = caster
      moveto(@caster.x, @caster.y)
      @character_name = char_name; @character_index = char_index
      vel = 9 if vel > 9
      @move_speed = vel
      @move_frequency = 4
      @range = range
      @priority_type = 1
      @weapon = weapon
      @disposed = false
      set_direction(@caster.direction)
    end
    
    def update
      return if disposed?
      if @range == 0; $game_player.hit = 0; dispose; return; end
      super
      @sprite.update if !@sprite.disposed?
      move_straight(direction) if !moving? and @range > 0
      if @on_next_update; dispose; return; end
      activate(check_enemy_trigger)
    end
    
    def move_straight(d, turn_ok = true)
      case d
      when 2
        if $game_map.counter?(x, y + 1)
          @through = true
        end
      when 4
        if $game_map.counter?(x - 1, y)
          @through = true
        end
      when 6
        if $game_map.counter?(x + 1, y)
          @through = true
        end
      when 8
        if $game_map.counter?(x, y - 1)
          @through = true
        end
      end
      super(d, turn_ok = true)
      if !$game_map.counter?(x,y)
        @through = false
      end
      @range -= 1 if not @range == 0
    end
    
    def passable?(x, y, d)
      x2 = $game_map.round_x_with_direction(x, d)
      y2 = $game_map.round_y_with_direction(y, d)
      return false unless $game_map.valid?(x2, y2)
      return true if @through || debug_through?
      return false unless map_passable?(x, y, d)
      return false unless map_passable?(x2, y2, reverse_dir(d))
      return false if collide_with_characters?(x2, y2)
      return true
    end
    
    def activate(enemy)
      return if enemy.is_a?(FalseClass)
      move_straight(direction); @trought = true
      enemy.animation_id = @weapon.animation_id
      r = rand(10); r -= 5
      attack = $game_party.members[0].atk + r
      criti = $game_player.crit?
      damage_enemy(enemy,attack,@caster,@weapon,criti)
      @on_next_update = true if not disposed?
    end
    
    def check_enemy_trigger
      $game_map.enemies.compact!
      case direction
      when 2
        attakable_enemies.each {|enemy| return enemy if enemy.x == x and enemy.y == y + 1}
      when 4
        attakable_enemies.each {|enemy| return enemy if enemy.x == x - 1 and enemy.y == y}
      when 6
        attakable_enemies.each {|enemy| return enemy if enemy.x == x + 1 and enemy.y == y}
      when 8
        attakable_enemies.each {|enemy| return enemy if enemy.x == x and enemy.y == y - 1}
      end
      return false
    end
    
    def dispose
      return if disposed?
      @on_next_update = false
      moveto(0,0)
      @character_name = ''; @character_index = 0
      @sprite.dispose if not @sprite.disposed?
      @disposed = true
    end
    
    def disposed?
      @disposed
    end
  end
end

class Sprite_Base < Sprite
  
  include Imperial_Config

  alias sprite_update update
  
  def update
    return if self.disposed?
    sprite_update
  end
  
  def animation_set_sprites(frame)
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @ani_bitmap1 : @ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @ani_mirror
        sprite.x = @ani_ox - cell_data[i, 1] / Animation_Reduce
        sprite.y = @ani_oy + cell_data[i, 2] / Animation_Reduce
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + cell_data[i, 1] / Animation_Reduce
        sprite.y = @ani_oy + cell_data[i, 2] / Animation_Reduce
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 300 + i
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / (100.0 * Animation_Reduce)
      sprite.zoom_y = cell_data[i, 3] / (100.0 * Animation_Reduce)
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
end
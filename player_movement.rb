require 'gosu'
require 'gosu_tiled'
require 'gosu_texture_packer'

class Tank
	attr_accessor :x, :y, :body_angle, :gun_angle
	
	def initialize(window, body, shadow, gun)
		@x = window.width / 2
		@y = window.height / 2
		@window = window
		@body = body
		@shadow = shadow
		@gun = gun
		@body_angle = 0.0
		@gun_angle = 0.0
	end
	
	def update
		atan1 = Math.atan(320 - @window.mouse_x)#atan only takes one argument
		atan2 = Math.atan(240 - @window.mouse_y)#atan only takes one argument
		atan = atan1 && atan2# This joins the 2 arguments together
		@gun_angle = -atan * 180 / Math::PI#because this needs x and y together
		@body_angle = change_angle(@body_angle,
			Gosu::KbA, Gosu::KbS, Gosu::KbA, Gosu::KbD)
	end
	
	def draw
		@shadow.draw_rot(@x - 1, @y - 1, 0, @body_angle)#Tank is made of only 3 layers
		@body.draw_rot(@x, @y, 1, @body_angle)#one on top of another. Gives nice
		@gun.draw_rot(@x, @y, 2, @gun_angle)#top-down 3D look.
	end
	
	private
	
	def change_angle(previous_angle, up, down, right, left)
		if @window.button_down?(up)
			angle = 0.0
			angle += 45.0 if @window.button_down?(left)#movement covering the
			angle -= 45.0 if @window.button_down(right)# 8 axes of movement
		elsif @window.button_down?(down)
			angle = 180.0
			angle -= 45.0 if @window.button_down(left)#Notice they come in pairs
			angle += 45.0 if @window.button_down(right)#Notice they come in pairs
		elsif @window.button_down?(left)
			angle = 90.0
			angle += 45.0 if @window.button_down?(up)
			angle -= 45.0 if @window.button_down(down)
		elsif @window.button_down?(right)
			angle = 270.0
			angle -= 45.0 if @window.button_down(up)
			angle += 45.0 if @window.button_down?(down)
		end
		angle || previous_angle
	end
end
	
class GameWindow < Gosu::Window

	MAP_FILE = File.join(File.dirname(
	__FILE__), 'island.json')
	UNIT_FILE = File.join(File.dirname(File.dirname(
	__FILE__)), 'media', 'ground_units.json')
	SPEED = 5
	
	def initialize
		super(640, 480, false)#Size of window, can changed to another size
		@map = Gosu::Tiled.load_json(self, MAP_FILE)
		@units = Gosu::TexturePacker.load_json(
			self, UNIT_FILE, :precise)
		@tank = Tank.new(self, 
			@units.frame('tank2_body.png'),#pictures that make up tank
			@units.frame('tank2_body_shadow.png'),
			@units.frame('tank2_dualgun.png'))
		@x = @y = 0
		@first_render = true
		@buttons_down = 0
	end
	
	def needs_cursor?
		true
	end
	
	def button_down(id)#escape function = quits game window
		close if id == Gosu::KbEscape
		@buttons_down += 1
	end
	
	def button_up(id)
		@buttons_down -= 1
	end
	
	def update
		@x -= SPEED if button_down?(Gosu::KbA)#Standard movement keys
		@x += SPEED if button_down?(Gosu::KbD)#in their standard keybinds
		@y -= SPEED if button_down?(Gosu::KbW)
		@y += SPEED if button_down?(Gosu::KbS)
		@tank.update	
			self.caption = "#{Gosu.fps} FPS. "
				'use WASD and mouse to control tank' #Friendly reminder message
	end
	
	def draw
		@first_render = false
		@map.draw(@x, @y)
		@tank.draw()
	end
end

GameWindow.new.show
		
		
		
		
		
		
		
		
	
	
	
	
	
	
	
	
	
	
	
	
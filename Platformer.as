package  {
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class Platformer extends MovieClip
	{

		//CONSTANTS
		const KEY_LEFT:uint   = 37;
		const KEY_UP:uint     = 38;
		const KEY_RIGHT:uint  = 39;
		const KEY_DOWN:uint   = 40;
		const KEY_A:uint      = 65;
		const KEY_W:uint      = 87;
		const KEY_D:uint      = 68;
		const KEY_S:uint      = 83;
		
		//VARS
		
		public var maxSpeed:Number = 18;
		public var minSpeed:Number = 0.1;
		public var moveSpeed:Number = 0.6;
		public var jumpPower:Number = 12;
		public var player:MovieClip;
		public var collisionVector:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var _gravity:Number = 0.6;
		private var _maxVelY:Number = 15;
		private var _friction:Number = 0.86;
		private var _playerVelocityX:Number = 0;
		private var _playerVelocityY:Number = 0;
				
		
		//FLAGS
		
		private var UP:Boolean = false;
		private var DOWN:Boolean = false;
		private var LEFT:Boolean = false;
		private var RIGHT:Boolean = false;
		
		private var JUMPING:Boolean = false;
		private var canJump:Boolean = true;
		
		
		//FUNCTIONS
		
		public function Platformer(char:MovieClip, collideV:Vector.<MovieClip> = null)
		{
			//INIT VARS
			
			player = char;
			collisionVector = collideV;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, initVars);
		}
			
		
		private function initVars(event:Event):void
		{
			
								 
			//LISTENERS
			
			stage.addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keys);
			stage.addEventListener(KeyboardEvent.KEY_UP, keys);
		}
		
		private function loop(event:Event):void
		{
			//Apply gravity
			_playerVelocityY += _gravity;
			
			//Apply Friction
			_playerVelocityX *= _friction;
			
			
			//Add Reft/Right Velocity
			if(LEFT == true)
			{
				_playerVelocityX -= moveSpeed;
			}else if(RIGHT == true)
			{
				_playerVelocityX += moveSpeed;
			}
			
			//Check collisions
			for each(var mc:MovieClip in collisionVector)
			{
				if(player.hitTestObject(mc))
				{
					//check up down
					if(mc.hitTestPoint(player.x, player.y + (player.height / 2)) || 
					   mc.hitTestPoint(player.x + (player.width / 2) - 5, player.y + (player.height / 2)) || 
					   mc.hitTestPoint(player.x - (player.width / 2) + 5, player.y + (player.height / 2)))
					{
						JUMPING = false;
						canJump = true;
						_playerVelocityY = 0;
						player.y = mc.y - ((mc.height / 2) + (player.height / 2));
						
					}else if(mc.hitTestPoint(player.x, player.y - (player.height / 2)) || 
					   mc.hitTestPoint(player.x + (player.width / 2) - 5, player.y - (player.height / 2)) || 
					   mc.hitTestPoint(player.x - (player.width / 2) + 5, player.y - (player.height / 2)))
					{
						_playerVelocityY = 1;
						player.y = mc.y + ((mc.height / 2) + (player.height / 2));
						
					}
				
					//check left/right
					if(mc.hitTestPoint(player.x - (player.width / 2), player.y))
					{
						_playerVelocityX = -(_playerVelocityX );
					}else if(mc.hitTestPoint(player.x + (player.width / 2), player.y))
					{
						_playerVelocityX = -(_playerVelocityX );
					}
				}
			}
			
			//Keep on stage
			if(player.x > stage.stageWidth)
			{
				player.x = 0;
			}else if(player.x < 0)
			{
				player.x = stage.stageWidth;
			}
			
			//Check for jumping
			if(UP == true)
			{
				if(canJump)
				{
					canJump = false;
					JUMPING = true;
					_playerVelocityY -= jumpPower;
				}
			}
			
			//Check for max speed;
			if(_playerVelocityX > maxSpeed)
			{
				_playerVelocityX = maxSpeed;
			}
			
			if(_playerVelocityY > _maxVelY)
			{
				_playerVelocityY = _maxVelY;
			}
						
			
			
			if(Math.abs(_playerVelocityX) < 0.01)
			{
				_playerVelocityX = 0;
			}
			
			
			//Pass velocity to player
			player.x += _playerVelocityX;
			player.y += _playerVelocityY;
			
		}
			
			
		private function keys(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			var flagger:Boolean;
			
			
			if(event.type == "keyDown")
			{
				flagger = true;
			}else if(event.type == "keyUp")
			{
				flagger = false;
			}
			
			if(key == KEY_LEFT || key == KEY_A)
			{
				LEFT = flagger;
			}
			
			if(key == KEY_RIGHT || key == KEY_D)
			{
				RIGHT = flagger;
			}
			
			if(key == KEY_UP || key == KEY_W)
			{
				UP = flagger;
			}
			
			if(key == KEY_DOWN || key == KEY_S)
			{
				DOWN = flagger;
			}
		}
		
						
	}
}

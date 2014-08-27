package com.wehaverhythm.air
{
	import flash.ui.Mouse;
	
	
	public class MouseManager
	{
		public static var instance:MouseManager;
		public var visible:Boolean;
		
		
		public function MouseManager(pvt:SingletonEnforcer)
		{
			super();
			visible = true; 
		}
		
		public static function getInstance():MouseManager
		{
			if ( instance == null ) instance = new MouseManager( new SingletonEnforcer() );
			return instance;
		};
		
		public function show():void
		{
			visible = true;
			Mouse.show();
		}
		
		public function hide():void
		{
			visible = false;
			Mouse.hide();
		}
		
		public function toggle():void
		{
			visible ? hide() : show();
		}
	}
}
internal class SingletonEnforcer{};
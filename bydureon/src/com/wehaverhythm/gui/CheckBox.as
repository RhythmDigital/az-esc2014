package com.wehaverhythm.gui 
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 *	CheckBox class
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Adam Palmer
	 *	@since  12.10.2008
	 */

	public class CheckBox extends MovieClip
	{
		public var currentState:Boolean;
		public static const CLICKED:String = 'CLICKED';
		

		public function CheckBox():void
		{
			currentState = false;
			gotoAndStop("unchecked");
			
			buttonMode = true;
			mouseChildren = false;

			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			if (currentState == false)
			{
				currentState = true;
				gotoAndStop("checked");
			} else {
				currentState = false;
				gotoAndStop("unchecked");
			}

			dispatchEvent(new Event(CLICKED, true));
		}		

		public function get state():Boolean
		{
			return currentState;
		}
		
		public function set state(newState:Boolean):void
		{
			currentState = newState;
			dispatchEvent(new Event(CLICKED, true));
			
			if (currentState == true) gotoAndStop("checked");
			else gotoAndStop("unchecked");
		}

		public override function toString():String
		{
			return "CheckBox";
		};
	}
}
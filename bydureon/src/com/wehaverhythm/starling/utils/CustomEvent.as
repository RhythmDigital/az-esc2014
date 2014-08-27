package com.wehaverhythm.starling.utils
{
	import starling.events.Event;
	
	public class CustomEvent extends Event
	{
		
		public function CustomEvent(type:String, params:Object=null, bubbles:Boolean=false)
		{
			super(type, bubbles, params); // params is actually 'data' in the superclass
		}
	}
}
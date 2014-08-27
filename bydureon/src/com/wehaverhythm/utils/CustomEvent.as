package com.wehaverhythm.utils
{	
	import flash.events.Event;
	
	
	public class CustomEvent extends Event 
	{		
		public var params:Object;
		
				
		public function CustomEvent(type:String, params:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.params = params;
		}		
	}
}
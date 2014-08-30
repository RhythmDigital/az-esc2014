package com.wehaverhythm.utils
{
	import cc.cote.feathers.softkeyboard.SoftKeyboard;
	import cc.cote.feathers.softkeyboard.layouts.EmailNumbersSymbolsSwitch;
	import cc.cote.feathers.softkeyboard.layouts.EmailSwitch;
	import cc.cote.feathers.softkeyboard.layouts.Layout;
	
	import starling.display.Stage;

	public class StarlingKeyboard extends ClipSprite
	{

		public var keyboard:SoftKeyboard;
		public function StarlingKeyboard(starlingStage:Stage, originalWidth:Number, originalHeight:Number)
		{
			super(originalWidth, originalHeight);

			new Theme(starlingStage);
			
			// Instantiate a keyboard with multiple layouts
			var l:Vector.<Layout> = new <Layout>[
				new EmailSwitch(EmailNumbersSymbolsSwitch),
				new EmailNumbersSymbolsSwitch(EmailSwitch)
			];
			
			// Create keyboard and add it to the stage
			keyboard = new SoftKeyboard(l, originalWidth, originalHeight);
			addChild(keyboard);
		}
	}
}
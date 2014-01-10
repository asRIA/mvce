package pl.asria.tools.display.ui 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Michal Mazur
	 */
	public class SimpleCheckboxGroup 
	{
		private var checkboxes:Vector.<SimpleCheckbox> = new Vector.<SimpleCheckbox>();
		
		public function SimpleCheckboxGroup() 
		{
			
		}
		
		public function addCheckBox(checkbox:SimpleCheckbox):void
		{
			checkboxes.push(checkbox);
			checkbox.addEventListener(MouseEvent.CLICK, onCheckboxClick);
			checkbox.addEventListener(Event.REMOVED_FROM_STAGE, onCheckboxRemoved);
		}
		
		private function onCheckboxClick(e:MouseEvent):void 
		{
			var checkbox:SimpleCheckbox = e.currentTarget as SimpleCheckbox;
			
			for each( var box:SimpleCheckbox in checkboxes)
			{
				box.selected = false;
			}
			
			checkbox.selected = true;
		}
		
		private function onCheckboxRemoved(e:Event):void 
		{
			var checkbox:SimpleCheckbox = e.currentTarget as SimpleCheckbox;
			
			checkbox.removeEventListener(Event.REMOVED_FROM_STAGE, onCheckboxRemoved);
			checkbox.removeEventListener(MouseEvent.CLICK, onCheckboxClick);
			checkboxes.splice(checkboxes.indexOf(checkbox), 1);
		}
		
		public function getSelectedIndex():int
		{
			for (var i:int = 0; i < checkboxes.length; i++)
			{
				if (checkboxes[i].selected)
					return i;
			}
			
			return -1;
 		}
		
		public function setSelectedIndex(selectedIndex:int):void
		{
			for (var i:int = 0; i < checkboxes.length; i++)
			{
				checkboxes[i].selected = false
			}
			
			checkboxes[selectedIndex].selected = true;
 		}
		
	}

}
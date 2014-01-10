package pl.asria.tools.fx.text
{
	import com.greensock.TweenLite;
	//import fl.text.TLFTextField;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	//import trzeci.utils.Debug;
	public class TextSimple
	{
		public static const NO_ACTIV_QUEEUE:Boolean = false;
		public static const ACTIV_QUEEUE:Boolean = true;
		
		public function TextSimple():void
		{
			
		}
		
		/**
		 * 
		 * @param	objectToInput
		 * @param	text
		 * @param	time
		 * @param	splitBy : "" - split by every char, "\n" - split by lines, ' ' - split by words... etc...
		 */
		public static function textInputer(objectToInput:DisplayObject, text:String, time:Number = 2, splitBy:String = ""):void
		{
			if (!(objectToInput is TextField) /*&& !(objectToInput is TLFTextField)*/) return;
			objectToInput['text'] = "";
			var tabElements:Array = text.split(splitBy);
			var tim:Timer = new Timer(Math.ceil(time * 1000 / tabElements.length));
			tim.addEventListener(TimerEvent.TIMER, timRespo);
			tim.start();
			var point:int = 0;
			function timRespo(e:Event):void
			{
				if (objectToInput == null) return;
				if (point == 0)
				{
					objectToInput['appendText'](tabElements[point]);
				}
				else
				{
					objectToInput['appendText'](splitBy.concat(tabElements[point]));
				}
				point++;
				if  (point == tabElements.length)
				{
					tim.removeEventListener(TimerEvent.TIMER, timRespo);
					tim.stop();
				}
			}
		}
		
		/*public static function textRepleacer(objectToInput:DisplayObject, text:String, time:Number = 2, splitBy:String = ""):void
		{
			if (!(objectToInput is TextField) && !(objectToInput is TLFTextField)) return;
			var curentContener:Array = [];
			var newContener:Array = [];
		}*/
		public static var queuee:Dictionary = new Dictionary();
		/**
		 * Zapewnie zmiane textu z obranym efektem
		 * @param	object instancja do której ma być przyczepiony efekt: TextField/ TLFTextField
		 * @param	newText nowa wartość textu
		 * @param	time czas zmiany
		 * @param	minAlpha minimalna wartość alpha jaką obierze pole tekstowe
		 * @param	animMoveObject {x:number, y:number, mirror:boolean} x,y - wartości przemieszczenie, mirror: powrót od przeciwnej strony
		 * @param	animBlurObject (x:number, y:number) x,y wartości blur w każdym z wymiarów
		 * @param	noQueue parametr przeskoczenia, zalecany paramert NO_ACTIV_QUEEUE:false, jeśli animacja jest aktualnie zajęta to kolejkuje kolejne komunikaty. w innym przypadku wymusza zmianę natychmiast.
		 * @param	useHTMLtext : dmyślnie ustawienie renderingu HTML dla pola tekstowego
		 * @param	hardChange : zmienia, nawet jak jest zawartość taka sama
		 */
		public static function changeText(
			object:Object, newText:String, 
			time:Number = 0.2, minAlpha:Number = 0,
			animBlurObject:Object = null, 
			animMoveObject:Object = null, 
			noQueuee:Boolean = NO_ACTIV_QUEEUE,
			useHTMLtext:Boolean = false,
			hardChange:Boolean = false
		):void
		{
			if (object == null) return;
			if ((!(object is TextField))/* && (!(object is TLFTextField))*/) 
			{
				//Debug.error("TextSimple: No Text object in chamgeText");
				return;
			}
		
			if (NO_ACTIV_QUEEUE == noQueuee)
			{
				if (queuee[object] != undefined)
				{
					queuee[object].push([object, newText, time, minAlpha, animBlurObject, animMoveObject, ACTIV_QUEEUE, useHTMLtext,hardChange]);
				
					return;
				}
				else
				{
				
					queuee[object] = [[object, newText, time, minAlpha, animBlurObject, animMoveObject, ACTIV_QUEEUE, useHTMLtext,hardChange]];
				}
			}
			
			//MouseSimple.focusBlinkUnregisterForTime(object, time);
			var timer:Timer;
			var basicState:Object;
			var semaphores:Number = 0; // czy nastała zmiana
			
			//Debug.debug("ANimText");
			if ((hardChange == false) && (object.text == newText)) 
			{
				//Debug.debug("no change" + [hardChange, object.text == newText]);
				semaphores++;
				cleaner();
			}
			else
			{
				//Debug.debug("change");
				
				
				basicState = {}
				for (var name:String in animMoveObject) 
				{
					//basicState[name] = object[name];
				}
				//basicState = { alpha:object.alpha, x:object.x, y:object.y, z:object.z};
				
				
				
				//if (animBlurObject != null) AnimBlur.blurTween(object as DisplayObject, 1, animBlurObject.x, 1, animBlurObject.y, time / 2);
				//if (animMoveObject != null) TweenLite.to(object, time / 2, { alpha:minAlpha, x:animMoveObject.x+basicState.x, y:animMoveObject.y+basicState.y} );

					timer = new Timer(time * 500, 1);
					timer.addEventListener(TimerEvent.TIMER, changeTextEvent);
					timer.start();
					animMoveObject.yoyo = true;
					animMoveObject.onComplete  = cleaner;
					TweenLite.to(object, time / 2, animMoveObject );

				//else
				//{
					//animMoveObject.onComplete  = changeTextEvent;
				//}
				
				//if (animMoveObject != null) T
				//else  TweenLite.to(object, time / 2, { alpha:minAlpha } );
			}
			
			
			
			function changeTextEvent(e:TimerEvent = null):void
			{
				
				
				if (useHTMLtext) 
				{
					//Debug.debug("SET HTML:" + newText);
					object.htmlText = newText;
				}
				else  
				{
					object.text = newText;
				}
				/*
				//object.autoSize = TextFieldAutoSize.RIGHT;
				if (animBlurObject != null) 
				{
					//AnimBlur.blurTween(object as DisplayObject,  animBlurObject.x, 1, animBlurObject.y, 1, time / 2, cleaner);
					semaphores++;
				}
				if ((animMoveObject!=null)&&(animMoveObject.mirror == true))
				{
					object.x = basicState.x - animMoveObject.x;
					object.y = basicState.y - animMoveObject.y;
				}
				
				if (animMoveObject != null) 
				{
					semaphores++;
					TweenLite.to(object, time / 2, {  alpha:basicState.alpha, x:basicState.x, y:basicState.y, onComplete:cleaner} );
				}
				else TweenLite.to(object, time / 2, { alpha:basicState.alpha, onComplete:cleaner} );*/
			}
			
			function cleaner():void
			{
				semaphores--;
				if (semaphores == 0)
				{
					if (queuee[object].length > 0)
					{
					
						(queuee[object] as Array).shift(); // kasuje element z kolejki najnowszy
						
					}
					
					if (queuee[object].length > 0)
					{
					
						changeText.apply(null, (queuee[object] as Array).shift());
						
					}
					else
					{
						queuee[object] = null;
						delete queuee[object];
					}
				}
			}
			
		}

	}
}
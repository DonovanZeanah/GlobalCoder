/*
clipStore := new ClipboardStore()
;clipStore.watchClips()
clipStore.saveClip("test1")
clipStore.showMenu()


class ClipboardStore {
   __New() {
      this.testFnObj := this.testFn.bind(this)
   }
   watchClips() {
      Loop {
         Clipboard := ""
         ClipWait
         this.saveClip(Clipboard)
      }
   }
   saveClip(clip) {
      testFnObj := this.testFnObj
      Menu, myMenu, Add, %clip%, % testFnObj
   }
   testFn() {
      MsgBox, Hi
   }
   showMenu() {
      Menu, myMenu, Show
   }
}

*/




clipStore := new ClipboardStore()
Return

$F1:: clipStore.ShowMenu()

class ClipboardStore {
   __New() {
      this.OnClipboardChange := new this.OnClipboard()
   }
   
   __Delete() {
      this.OnClipboardChange.Clear()
   }
   
   ShowMenu() {
      Menu, myMenu, Show
   }
   
   class OnClipboard {
      __New() {
         this.testFnObj := ObjBindMethod(this, "InsertClip")
         this.Clip := ObjBindMethod(this, "SaveClip")
         OnClipboardChange(this.Clip)
      }
      
      SaveClip(type) {
         if (type = 1) {
            testFnObj := this.testFnObj
            Menu, myMenu, Add, % Clipboard, % testFnObj
         }
      }
      
      InsertClip() {
         Clipboard := A_ThisMenuItem
         Sleep, 50
         Send ^v
      }
      
      Clear() {
         OnClipboardChange(this.Clip, 0)
      }
   }
}


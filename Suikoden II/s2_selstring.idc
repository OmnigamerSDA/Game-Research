
#include <idc.idc>

static ConvertChar(ptr, comment)
{
   auto charset, chr;
   charset = "     $<>^    »\n¦"
      	" abcdefghijklmno"
      	"pqrstuvwxyzéàèùâ"
      	"êîôûäëïöüçæABCDE"
      	"FGHIJKLMNOPQRSTU"
      	"VWXYZÉÀÈÙÂÊÎÔÛÄË"
      	"ÏÖÜÇ&,.!?()+=***"
      	"****************"
      	"****************"
      	"***:%#Æß01234567"
      	"89:;\"'`****áíóúñ"
      	"ÍÓÚÑ¡¿**********"
      	"****************"
      	"****************"
      	"*********abcdefg"
      	"hijklmnopqrstuvw"
	"xyzéàèùâêîôûäëïö";

   chr = Byte(ptr);
   if(chr >= 0x10)
   {
   	comment = comment + substr(charset, chr, chr + 1);
   }
   else
   {
   	if(chr < 5)
   	{
   		;
   	}
   	else if(chr == 5)
   	{
   		comment = comment + "{Hero}";
   		ptr = ptr + 1;
   	}
   	else if(chr == 6)
   	{
   		ptr = ptr + 1;
   		comment = comment + "{Delay=" + ltoa(Byte(ptr), 10) + "}";
   	}
   	else if(chr == 7)
   	{
   		ptr = ptr + 1;
   		comment = comment + "{Pause=" + ltoa(Byte(ptr), 10) + "}";
   	}
   	else if(chr == 8)
   	{
   		ptr = ptr + 1;
   		comment = comment + "{Color=" + ltoa(Byte(ptr), 16) + "}";
   	}
   	else if(chr < 0xD)
   	{
   		;
   	}
   	else if(chr < 0xF)
   	{
   		comment = comment + "\n";
   	}
   	else
   	{
   		comment = comment + "{Clear}";
   	}
   }
   
   return comment;
}

static StrFromCaretPos()
{
   auto start, end, ptr, comment;
   auto str_start, tmp, len;
   auto special;
   
   start = ScreenEA();
   if(start == BADADDR)
         return;
   
   //Arbitrarily limit the search to 400 bytes from the caret.
   end = SegEnd(start) > start + 400 ? start + 400: SegEnd(start);
   if(end == BADADDR)
      return;
   
   str_start = len = special = 0;
   comment = "";
   //Message("Search start/end (%x, %x)\n", start, end);
   for(ptr = start; ptr < end; ptr = ptr + 1)
   {
      if(str_start > 0)
      {
         if(Byte(ptr) == 0 && Byte(ptr - 1) > 8)
	 {
	    MakeRptCmt(str_start, comment);
	    str_start = 0;
	    break;
         }
         else
         {
            if(special == 0)
            {
               comment = ConvertChar(ptr, comment);
               len = len + 1;
            }
            if(Byte(ptr) < 8 && special == 0)
	    {
	       special = 1;
            }
            else
            {
               special = 0;
            }
         }
      }
      else
      {
         str_start = ptr;
	 comment = ConvertChar(ptr, comment);
         len = 1;
      }
   }
}

static StrFromSelection()
{
   auto charset, start, end, ptr, comment;
   auto str_start, tmp, len;
   
   charset = "     $<>^    »\n¦"
   	" abcdefghijklmno"
   	"pqrstuvwxyzéàèùâ"
   	"êîôûäëïöüçæABCDE"
   	"FGHIJKLMNOPQRSTU"
   	"VWXYZÉÀÈÙÂÊÎÔÛÄË"
   	"ÏÖÜÇ&,.!?()+=***"
   	"****************"
   	"****************"
   	"***:%#Æß01234567"
   	"89:;\"'`****áíóúñ"
   	"ÍÓÚÑ¡¿**********"
   	"****************"
   	"****************"
   	"*********abcdefg"
   	"hijklmnopqrstuvw"
	"xyzéàèùâêîôûäëïö";
      
   start = SelStart();
   if(start == BADADDR)
         return;
      
   end = SelEnd();
   if(end == BADADDR)
      return;
   
   str_start = len = 0;
   comment = "";
   Message("Search start/end (%x, %x)\n", start, end);
   for(ptr = start; ptr < end; ptr = ptr + 1)
   {
      if(str_start > 0)
      {
         if(Byte(ptr) == 0 || ptr == end - 1)
	 {
	    if(len > 2)
	    	MakeRptCmt(str_start, comment);
	    str_start = 0;
         }
         else
         {
            comment = comment + substr(charset, Byte(ptr), Byte(ptr) + 1);
            len = len + 1;
         }
      }
      else
      {
         str_start = ptr;
         comment = substr(charset, Byte(ptr), Byte(ptr) + 1);
         len = 1;
      }
   }
}

static S2_SelString()
{
   if(SelStart() == BADADDR)
      StrFromCaretPos();
   else
      StrFromSelection();
}

/*static main()
{
   S2_SelString();
}*/
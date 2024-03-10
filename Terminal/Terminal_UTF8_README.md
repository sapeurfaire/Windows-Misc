### TL;DR:

You see strange and meaningless symobls in the Windows Terminal intead of the non-English characters or emoji you had likely exptected.  If this occurred beasue Windows was trying to show Unicode stored as UTF-8 rather than UTF-16, one of the methods provided here may correct the issue.

#### CAVEAT EMPTOR (DATA CORRUPTION WARNING)

The instructions and code provided here prevent Windows from "falling back" to the use of legacy codepages when it detects characters not stored as UTF-16. If you use an application or program that require a legacy codepage after using one of the hacks here, it is possible that the program could cause data corruption.

### Solution Options

Each of the following links provides a different means of accomplishing the same end.  You only need to use one of them.  All of them require a reboot.

[Configure Windows 10/11 to "fall back" to UTF-8 in the Windows UI ("manually")](https://github.com/sapeurfaire/Windows-Misc/blob/main/Terminal/systemwide-utf8-fallback.md)<br>
[Configure Windows 10/11 to "fall back" to UTF-8 by running a PowerShell script](https://github.com/sapeurfaire/Windows-Misc/blob/main/Terminal/systemwide-utf8-fallback.ps1)<br>
[Configure Windows 10/11 to "fall back" to UTF-8 by importing registry settings](https://github.com/sapeurfaire/Windows-Misc/blob/main/Terminal/systemwide-utf8-fallback.reg)<br>

### Details

Prior to the widespread adoption of the internet it was acutally pretty common to see strange or incorrect characters on a computer when accessing certain kinds of data. Documents from people whose native language differed from our own. Data from an application that we didn't have access to that used uncommon symbols from our own language.  

This resulted from the relatively large number of [character encoding](https://en.wikipedia.org/wiki/Character_encoding) schemes in use for representation of [orthographic](https://en.wikipedia.org/wiki/Orthography) data.  

Most of these have been supplanted by [Unicode](https://en.wikipedia.org/wiki/Unicode). But it's important to understand that the "Unicode standard" has not yet reduced the number of machine level character encoding schemes in use to the "just one" implied by it's name.

This is not due to lack of adoption. On most systems it is reasonable to assume that issues with character display are the result of incomplete, incorrect, or out-of-date Unicode implementations.  A major -- we might even say *unitary* -- exception to this is Microsoft Windows.  

Which is strange from a historical perspective. Microsoft was an early adopter of Unicode.  Why should any Unicode characters appear "incorrectly" in Windows?  Ironically, Unicode itself supports more than one encoding.

Early in the history of Unicode, Microsoft chose to use [UTF-16](https://en.wikipedia.org/wiki/UTF-16) in it's then new [Windows NT](https://en.wikipedia.org/wiki/Windows_NT) operating system.  (Which you are using a descendant of, if the problem described in this note applies to your system).  While there are other exceptions -- Java, for example -- the majority of other systems used to store and process data would go on to use [UTF-8](https://en.wikipedia.org/wiki/UTF-8).  

UTF-16 will contain a [BOM](https://en.wikipedia.org/wiki/Byte_order_mark) and may contain null-bytes. If a character contain neither of these, and Windows did not otherwise have an explicit indication of the correct encoding to use, it will assume the data should be displayed using a legacy 8-bit codepage or ["locale"](https://en.wikipedia.org/wiki/Locale_(computer_software)). The specific locale used would be based on the primary language chosen by the user that installed the system. 

In some cases this will not affect the intelligibility of characters that are actually UTF-8 encoded. English and numerous other Western European languages use a [(common subset)](https://en.wikipedia.org/wiki/ASCII) of characters that are encoded in exactly the same form in UTF-8 as well as the legacy codepages those languages had previously relied on.  

Speakers of non-Western languages or applications that require less common symbols are much more likely to be impacted when Windows attempts to display UTF-8 encoded characters using a legacy codepage. (The author of this README has idly wondered if native English speakers would be aware of the issue if it hadn't impacted their ability to use emoji.)  

Recent builds of Windows offer experimental support for setting UTF-8 as the "fallback" locale, which would prevent the issue from occuring.  The remainder of this note details how to do this.  Please do re-read and heed the warning above before following any of the procedures on offer.  Using any of them could impact the ability for legacy applications to display data correctly, or worse, cause them to actively damage the data you entrust to them.

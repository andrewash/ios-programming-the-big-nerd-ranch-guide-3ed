// flag is ON == Tells the compiler... "When you come across WSLog, see NSLog"
#define WSLog(...) NSLog(__VA_ARGS__)

//// flag is OFF == Tells the compiler... "Make all WSLog calls invisible to the compiler"
//#define WSLog(...) do {} while(0)

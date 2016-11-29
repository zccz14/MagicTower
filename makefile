# Build
OUTPUT = main.exe
OBJS = main.obj
RESS = icon.res
# Configuration
SrcPath = src
BuildPath = build

Assembler = C:\masm32\bin\ml.exe
AssemblerOption = -c -coff 

ResourceCompiler = C:\masm32\bin\rc.exe

Linker = C:\masm32\bin\link.exe
LinkOption = -subsystem:windows

# Targets Rule
$(OUTPUT): $(OBJS) $(RESS)
	$(Linker) $(BuildPath)/$(OBJS) $(BuildPath)/$(RESS) $(LinkOption)
%.obj: $(SrcPath)/%.asm
	$(Assembler) $(AssemblerOption) -Fo $(BuildPath)/$@ $<
%.res: $(SrcPath)/%.rc
	$(ResourceCompiler) -fo $(BuildPath)/$@ $<
clean:
	- rm $(BuildPath)/$(OBJS)
	- rm $(BuildPath)/$(RESS)
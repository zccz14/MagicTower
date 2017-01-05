# Build
OUTPUT = main.exe
OBJS = main.obj background.obj images.obj
# Configuration
SrcPath = src

Assembler = C:\masm32\bin\ml.exe
AssemblerOption = -c -coff 

ResourceCompiler = C:\masm32\bin\rc.exe

Linker = C:\masm32\bin\link.exe
LinkOption = -subsystem:windows -OUT:$(OUTPUT)

# Targets Rule
$(OUTPUT): $(OBJS)
	$(Linker) $(OBJS) $(RESS) $(LinkOption)
%.obj: $(SrcPath)/%.asm
	$(Assembler) $(AssemblerOption) -Fo $@ $<
clean:
	- rm $(BuildPath)/$(OBJS)
	- rm $(BuildPath)/$(RESS)
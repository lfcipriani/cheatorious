cheatsheet_for "Simple VIM" do
  
    description "A simple VIM cheatsheet for tests"
    author      "Luis Cipriani", "github.com/lfcipriani"
    version     "1.0.0"
  
    key_separator " "
  
    key :control, "^"
    key :esc    , "<esc>"
    key :leader , ","

    __ "Enter insertion mode", "i"
    __ "Exit insertion mode" , _esc
  
    section "Basic Movement" do
        __ "character left, right, line up, line down", "h", "l", "k", "j"
        __ "word/token left, right"                   , "b", "w"
    end
  
    section "Scrolling" do
        __ "scroll line up, down", (_control "E"), (_control "Y")
        __ "scroll page up, down", (_control "F"), (_control "B")
    end
  
    section "Files" do
        __ "Open file", ":e"
    
        section "Saving" do
            __ "Save file", ":w"
        end
    end
  
end
input := "<your input here>"
lines := StrSplit(input, "\n")
output := 0
partOne := False
nums := ["0","1","2","3","4","5","6","7","8","9","zero","one","two","three","four","five","six","seven","eight","nine"]

For i, line in lines {
    out := []
    j := 1
    While j <= StrLen(line){
        foundIndex := -1
        For i,v in nums{
            if (partOne && i > 10){
                Break
            }
            l := StrLen(v)
            s:= SubStr(line,j,l)

            If (v == s){
                j++
                foundIndex := i
                Break
            }
        }
        If (foundIndex == -1){
            j++
            Continue
        }

        If (foundIndex > 10){
            foundIndex -= 10
        }
        out.Push(nums[foundIndex])
    }
    output += out[1] . out[out.Length]
}
MsgBox "out " . output
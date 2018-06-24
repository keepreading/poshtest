#Doin somethin
#installing view 3.5.2
#2/15/2017

#Sam Kachar II  ext. 5941

[string[]]$computers = cat 'C:\SCCM\Pulse\Pulsev5Machines.txt'
$total = $computers.Count
$maxjobs=80 #Number of Jobs to Run at one time
#$chunksize = 2 #Number of machines to run per job; thought i would use this but decided it better to just run one machine per job.
$jobs=@()  #Initialize $job variable

#script block that will be called by start-job
 $sb = {
    param($computers,$i)
   
   $comp = $computers[$i]
    
    if (Test-Connection -computername $comp -Count 1 -Quiet){ #is the machine online??? If online log as online, failure will be logged

       
      
      try{
        
        $OSVer = (gwmi -ComputerName $comp -Class win32_operatingsystem).version
        if($OSVer.startswith(1))
            {
            $comp | Out-File -FilePath 'C:\SCCM\Pulse\Win10\Win10PulseV5.txt' -Append -Force
                                }
        if($OSVer.startswith(6))
            {
            $comp | Out-File -FilePath 'C:\SCCM\Pulse\Win7\Win7PulseV5.txt' -Append -Force
                                } 
        }
       
     catch
     {
          "$comp" | Out-File -LiteralPath "c:\sccm\Pulse\failed\failed.txt" -force -Append
           }
             
        
                                                        }
    
        #If the machine was offline then this will log the machine name for later processing

   else {
        
        "$comp" | Out-File -literalpath "c:\sccm\Pulse\offline\offline.txt" -force -Append
       }
    
}
#This for loop is what controls the number of jobs and fire's them off
for ($i=0;$i -lt $total; $i++){
    $jobs += Start-Job  -ScriptBlock $sb -ArgumentList($computers,$i)
   
    #creates a variable with job objects eq to running state
    $running = @($jobs | ? {$_.State -eq 'Running'})

    While ($running.Count -ge $maxjobs) { #if the count of currently running jobs is ge the set ceiling 
    $finished = Wait-Job -Job $jobs -Any   #use the wait-job cmdlet to pause script execution from creating anymore jobs
    $running = @($jobs | ? {$_.State -eq 'Running'}) #once a job finishes this line runs for re-evaluation
    }
}
Wait-Job -Job $jobs > $null #this line pauses script execution until all remaing jobs finish, i tested this and it works


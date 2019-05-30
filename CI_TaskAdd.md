## Jenkins Installation Setup Guide ## 

## Add Build ONL RSD ##


*  Add system credentials used while need using ssh command to remote server.

   ![screenshot](img/task_0_0_1.png) 

*  User name and password for specific credentials. 

   ![Screenshot](img/task_0_0_2.png) 
   
   ![Screenshot](img/task_0_0_3.png) 

*  Add remote SSH server 

   ![screenshot](img/task_0_1_0.png) 


   ![screenshot](img/task_0_1_1.png) 

 
   ![screenshot](img/task_0_1_2.png) 
   

*  Add "Build_ONL_RF" Task. 

   ![screenshot](img/task_1.png) 


   ![screenshot](img/task_2.png) 


*  Bind "Build_ONL_RF" Task to Slave node "Build_RSD_PSME".

   ![screenshot](img/task_3.png) 

*  Use following POST to triger this build task. 

   ```
   http://172.17.10.60:8080/job/Build_ONL_RF/build?token=05a8ab5 
   ```

   ![screenshot](img/task_4.png) 


*  Add shell command in this remote build server. 


   ![screenshot](img/task_5.png) 


   ![screenshot](img/task_6.png) 

   ```
   if [ ! -d OpenNetworkLinux ];then git clone https://github.com/opencomputeproject/OpenNetworkLinux.git; fi
   cd OpenNetworkLinux
   git checkout 05a8ab5
   rm -rf RSD-Redfish
   git clone https://github.com/edge-core/RSD-Redfish.git
   cd RSD-Redfish/PSME/build 
   docker start RSD_213
   sleep 5
   ./One_punch_build.sh
   echo "Build Finished!!"
   ```

*  Added target SSH server node. 

   ![screenshot](img/task_7.png) 


   ![screenshot](img/task_8.png) 

## Add RF Auto Test Task ##


*  Added new task. 

   ![screenshot](img/task_1.png) 


   ![screenshot](img/task_9_0.png) 

*  Added new git url and specific slave node "Robot_PSME_Auto_Test" to run this task. 

   ![screenshot](img/task_9.png) 


*  Add git url and its credential.

   ![screenshot](img/task_10.png) 


*  This test will be triggered successful built "Build_ONL_RF" Task 

   ![screenshot](img/task_11.png) 


*  Add robot auto test shell command. 

   ![screenshot](img/task_12.png) 


*  After test need have report to recored.

   ![screenshot](img/task_13.png) 


*  Start build and test.

   ![screenshot](img/task_build.png) 



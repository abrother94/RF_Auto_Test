## RSD Redfish PSME Test Automation ##
* Reference from [OpenBMC Test Automation Redfish part](https://github.com/openbmc/openbmc-test-automation)

**Interface Feature List**
* REST
* DMTF Redfish

## Installation Setup Guide ##

* [Robot Framework Install Instruction](https://github.com/robotframework/robotframework/blob/master/INSTALL.rst)

* Miscellaneous
Packages required to be installed for OpenBmc Automation.
Install the packages and it's dependencies via `pip`

    REST base packages:
    ```
    $ pip install -U requests
    $ pip install -U robotframework-requests
    $ pip install -U robotframework-httplibrary
    ```

    Python redfish library packages:
    For more detailed intstructions see [python-redfish-library](https://github.com/DMTF/python-redfish-library)
    ```
    $ pip install redfish
    ```

    SSH and SCP base packages:
    For more detailed installation instructions see [robotframework-sshlibrary](https://pypi.python.org/pypi/robotframework-sshlibrary)
    ```
    $ pip install robotframework-sshlibrary
    $ pip install robotframework-scplibrary
    ```

## Test item ##

`redfish/`:  Test cases for DMTF Redfish-related feature supported.

`redfish_eit/`: Test cases for ONLP EIT test.

* How to run onl EIT test:

    onl EIT test:
    ```
    $ eit.sh
    ```

    all test:
    ```
    $ all.sh
    ```
* How to run CI test:
    ```
### CI Build and Test Architecture Model

```
+-----------------------+            +----------------------+
|                       |   1.       |                      |
|  172.17.10.60         +------------>   172.17.10.64       |
|Agent                  |            | Agent Build_RSD_PSME |
|Robot_PSME_Auto_Test   |            |                      |
|                       |            |                      |
|  Jenkins Service      |            |                      |
|       :8080           |            |                      |
+-------------------+---+            +-----+----------------+
                    |                      |
                    |                      |
                    |3.                    | 2.
                    |                      |
                    |                      |
                 +--v----------------------v---+
                 |    Target: Switch or OLT    |
                 |    172.17.10.x              |
                 |                             |
                 |                             |
                 +-----------------------------+


 1. Start Build on Agent Build_RSD_PSME

 2. After build finished, deploy PSME package to Target and start up RF service.

 3. Start robot framework automation test to target.


```    
    ```
    Jenkins build and deploy to device and run all.sh test:
    ```
    $ 
    ```

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

    Jenkins build and deploy to device and run all.sh test:
    ```
    $ 
    ```

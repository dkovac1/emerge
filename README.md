# Project EMERGE

The EMERGE project seeks to provide African policy makers, academics, investors, and citizens with the tools and knowledge required
to increase the production of clean energy and the sustainable use of resources while bridging cultural and socioeconomic divides. In
order to simulate scenarios that optimize the use of current resources while taking into account social, climatic, economic, and
technical constraints, EMERGE will co-design and test a Toolbox by integrating and building upon existing tools, methodologies, and
approaches. Additionally, a Knowledge Base with a collection of initiatives, materials, and knowledge-exchange activities will be
created. The North Western Africa (Morocco), Niger river region (Mali/Nigeria), and Mozambique are three African ecosystems where
EMERGE will develop knowledge communities through a participatory approach.

## Methodology


The EMERGE methodology is based on a cross-sectoral approach aimed at developing a **user-friendly set of tools 
connected through a CSA** that reflect on **economic, environmental, social and technical aspects** of the energy system. 
The methodology is aimed at using the EMERGE toolbox as a means for energy system modelling through which 
**different experts and stakeholders (both AU and EU) will be connected**. 
Through iterative co-design process the toolbox will be improved to reflect on user needs and through the 
implementation of the Toolbox on the pilot sites the experts will be able to **tailor policies and regulations 
tailored to African needs that will support the clean energy transition**.

## Database

In order to support the EMERGE Toolbox, a **open database** will be developed by BrainIT and based on CSA. 
The database will include data of existing databases such as FAOSTAT, AQUASTAT, WORLBANK, WIOD, Copernicus, 
GEOSS, etc. and will be organised in structured manner. The EMERGE database will be easy to search and 
modify which will make it easy to implement a Knowledge Base and new test cases. The database will also 
include different sectors, thus enabling the representation of social, economical, environmental and 
technical parameters.

The Tools in the EMERGE Toolbox are designed and implemented following the same Common System Architecture (CSA), 
defined as a set of social, technologic, and economic requirements for the design of energy system analysis solutions. 
The Common System Architecture will be based on relevant economic, social, environmental and technical requirements 
identified through a codesign process that will involve citizens and relevant stakeholders from the energy sector 
value-chain (WP1). This will identify key frameworks, engagement strategies and preferences in the energy
system modelling, which will guide the development of the tools in EMERGE Toolbox. This process will be 
complemented by technical(standardisation, data exchange and interoperability) requirements (WP2, WP3) and by a 
holistic overview of regulatory frameworks, policies, enabling energy markets, and business models (WP4) 
that support the implementation of actions that stimulate the integration of clean technologies in the energy systems. 
Through this design methodology, the EMERGE project will provide solutions that are, at their core:
- Tailored to different climate, social, technologic, and economic conditions
- Flexible, interoperable, and replicable

## Tools

### Climate Energy Policies Impact Assessment Tool (CEPIA) by Artelys

**CEPIA** is an excel based tool combined with an integrated Python module allowing for user friendly assessment of
energy and climate scenarios through multiple economic and environmental indicators. The modelling in
the tool uses a mixed bottom- up approach and optimisation of the power supply: 

(i) The energy consumption of the different sectors (including agriculture, water, transport, residential,
commercial and industry) can be estimated based on a detailed representation of the consumers of the sector. For
example, the energy consumption of the residential sector is based on the estimation of the consumption for households 
(cooking, electric appliances, air cooling) multiplied by the number of households. 

(ii) Based on the estimation of the power demand, an optimisation of the power generation mix is realized 
resulting in installed capacity and generation, total cost, CO2 emissions, and energy import dependency.


### PowerSyBl by Artelys

PowSyBl is an open-source framework written in Java, dedicated to **modelling and simulating of European electricity 
networks**. It is currently used by European TSOs for transmission network investment
planning, network security analysis following incidents and the merging of individual network models on a 
European scale. A key characteristic of PowSyBl is its **modular design**, at the core of the open-source approach, 
which enables developers to extend or customize its features by providing their own plugins, making it a perfect 
candidate to be added to the EMERGE toolbox and customized to an African context. 
Part of this framework is the **METIRX** tool, on which Artelys will focus. 
METRIX is an optimisation model, developed in C++, used to assess preventive and curative actions to 
respect the network constraints, using DC approximation. Thus, it allows for annual techno-economic studies 
of **power networks** covering medium-term development and operation studies, with an hourly timestep resolution.

*Improvements beyond state-of-the-art*: As mentioned above, this project is an opportunity to broaden the 
scope of PowSyBl users to the African continent and make it easily configurable to any modeller. 
This project will also be an opportunity to expand the possible modelling features of METRIX. 
To account for **the need for flexibility on electricity grids**, Artelys will implement an abstract 
modelling of flexibility assets in the METIRX library and specify the model in case of electric batteries. 
The main difficulty will be to pilot flexibility solutions while the resolutions for each timestep are 
totally independent. The goal of the evolution will be to integrate the added value of flexibility 
solutions such as battery storage, by modelling the interlinkages between the modelled timesteps, 
either by coupling the timesteps during the optimisation over a time period, or by propagating operational 
strategies for the batteries based on the marginal cost. The entire solution will give way to **cost-benefit 
analyses of storage installations** on the transmission network, while integrating network constraints in the 
case of rather limited grid capacities. The original abstract flexibility modelling proposed in the project, 
will create the basis for additional modelling layers to define specific flexible assets constraint by next users. 
For instance, one could model microgrids as a flexible asset with additional constraints, capable of 
injecting or retrieving power from the main grid, thus analysing the benefits or not of further connecting 
microgrids to the main grid in an African context.


### HOSTING CAPACITY by CIRCE

Hosting Capacity tool has an algorithm implemented that calculates the **total amount of power 
that can be installed in each node of the grid**. This information is static and must be updated once 
new generation or consumption are installed. The data requirements for this tool include historical 
demand data and historical or forecasted production from generation units (for renewables existing open 
source tools can be used, e.g. PV GIS6 for solar). Additionally, static data regarding grid topology 
needs to be available. Although the tool can be used for distribution and transmission system, it is 
more suitable for the **distribution system** due to its static nature. This makes it suitable for planning 
of **industrial, rural and city areas**. Even more so, the tool can integrate the transportation network.


### OPTIMAL STORAGE PLACEMENT by CIRCE

The Optimal Storage Placement tool has an optimization algorithm implemented that calculates the best 
locations in the grid to install storage systems. It is used to solve voltage and loading problems. 
The tool also performs the cost-benefit analysis based on the price of energy assets. In other words, 
the tool can provide an analysis of increased possibility for renewable energy sources penetration as 
a result of optimal storage placement and quantify economic benefits of such approach in comparison to 
the approach where grid investments are made for increased renewable energy penetration. This presents 
a strong policy making instrument for the regions with weaker grid.

*Improvements beyond state-of-the-art*: In scope of the EMERGE project, relation between the optimal 
storage placement and economic and environmental parameters will be established. The tool will enable 
evaluation of economical and environmental parameters (system costs, emission reduction, etc.) in relation 
to the storage placement in the grid. By establishing connection with the database, the tool will be 
able to **quantify the improvements of economic and environmental parameters** as a result of different 
storage placement that influence the capability of the system to integrate new renewable units. Such 
**innovative approach** will provide information for experts and policy makers on **optimal solutions for 
energy infrastructure improvement for higher penetration of renewable units**.


### GREENADVISE by UNIZAG

GREENADVISE is an investment advisor based on a Python module and used for the optimization of
small-scale energy systems on a community or small city scale. Its’ application can range
from household or building level to small city and is suitable for citizens and civil societies without the energy
background in formal education. Moreover, the capacity optimization for the used technologies such as 
PV plant, battery storage, heat pumps etc. is also included in the model. 

GREENADVISE finds optimal renewable capacities for the modelled system, develops hourly 
(or sub-hourly level based on user preference) optimized system operation, and finds 
economically optimal solutions. Therefore, model results with the optimal system capacities and 
operation displaying the economical results in form of savings and earnings, total system costs 
including CAPEX and OPEX costs, GHG emissions reduction and energy streams between the actors in the 
observed system on the user-defined time scale.

*Improvements beyond state-of-the-art*: The tool will be further developed by updating the user 
interface in order to enhance the user experience. The focus will be placed on the outputs of the 
tool as well as the benefits and co- benefits that would be achieved if the outputs of the tool 
would be implemented. Specifically, this means that results indicators will reflect the Sustainable 
Development Goals (e.g. percentage of self-consumption to contribute to **Affordable and clean energy**, 
air pollution reduction to contribute to **Good health and well being**, short and interactive descriptions 
of technologies and benefits for **Quality education** and similar). Moreover, the connection with the 
EMERGE database will be established to automate the data input and enhance user experience.

Besides the version suitable for citizens and general society, the tool will also be upgraded to second 
version by improving the code to enable **stochastic and robust modelling to address the uncertainty** of 
the model which will be used by energy planning experts for more complex calculations.
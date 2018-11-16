set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set val(x) 500
set val(y) 500

# Define options
set val(chan) Channel/WirelessChannel    ;# channel type
set val(prop) Propagation/TwoRayGround   ;# radio-propagation model

set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type. This can be changed.
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             2                      ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x)              500   			   ;# X dimension of topography
set val(y)              400   			   ;# Y dimension of topography  
set val(stop)		10.0			   ;# time of simulation end

# set up topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)

#Nam File Creation  nam - network animator
set namfile [open sample1.nam w]

#Tracing all the events and cofiguration
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#Trace File creation
set tracefile [open sample1.tr w]

#Tracing all the events and cofiguration
$ns trace-all $tracefile

# general operational descriptor- storing the hop details in the network
create-god $val(nn)

# configure the nodes
        $ns node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace ON

# Node Creation
set node1 [$ns node]


# Initial color of the node
$node1 color black

#Location fixing for a single node
$node1 set X_ 200
$node1 set Y_ 200
$node1 set Z_ 0

set node2 [$ns node]
$node2 color black

$node2 set X_ 200
$node2 set Y_ 400
$node2 set Z_ 0


# Node Creation
set node3 [$ns node]


# Initial color of the node
$node3 color black

#Location fixing for a single node
$node3 set X_ 350
$node3 set Y_ 400
$node3 set Z_ 0

# Node Creation
set node4 [$ns node]


# Initial color of the node
$node4 color black

#Location fixing for a single node
$node4 set X_ 100
$node4 set Y_ 200
$node4 set Z_ 0

# Node Creation
set node5 [$ns node]

# Initial color of the node
$node5 color black

#Location fixing for a single node
$node5 set X_ 100
$node5 set Y_ 400
$node5 set Z_ 0

# Node Creation
set node6 [$ns node]

# Initial color of the node
$node6 color black

#Location fixing for a single node
$node6 set X_ 100
$node6 set Y_ 300
$node6 set Z_ 0

# Node Creation
set node7 [$ns node]


# Initial color of the node
$node7 color black

#Location fixing for a single node
$node7 set X_ 400
$node7 set Y_ 300
$node7 set Z_ 0


#Size of the node
$ns initial_node_pos $node1 25
$ns initial_node_pos $node2 25
$ns initial_node_pos $node3 25
$ns initial_node_pos $node4 40
$ns initial_node_pos $node5 40
$ns initial_node_pos $node6 40
$ns initial_node_pos $node7 40


# For mobility 300= movement x value, 100=movement y value, 50=speed in m/s 
$ns at 2.0 "$node1 setdest 300 100 50"
$ns at 2.0 "$node2 setdest 100 100 40"
$ns at 1.0 "$node3 setdest 300 200 10"



#Create links between the nodes
$ns duplex-link $node4 $node6 2Mb 10ms DropTail
$ns duplex-link $node5 $node6 2Mb 10ms DropTail
$ns duplex-link $node6 $node7 1.7Mb 20ms DropTail


#Set Queue Size of link (n6-n7) to 10
$ns queue-limit $node6 $node7 10


#Give node position (for NAM)
$ns duplex-link-op $node5 $node6 orient right-down
$ns duplex-link-op $node4 $node6 orient right-up
$ns duplex-link-op $node6 $node7 orient right


#Monitor the queue for link (n2-n3). (for NAM)
$ns duplex-link-op $node6 $node7 queuePos 0.5
$ns duplex-link-op $node5 $node6 queuePos 0.5
$ns duplex-link-op $node4 $node6 queuePos 0.5





#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $node5 $udp
set null [new Agent/Null]
$ns attach-agent $node7 $null
$ns connect $udp $null
$udp set fid_ 1

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false


# #Setup a TCP connection
set tcp [new Agent/TCP]
$tcp set class_ 3
$ns attach-agent $node1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $node2 $sink
$ns connect $tcp $sink
$tcp set fid_ 2

# #Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $node3 $udp
set null [new Agent/Null]
$ns attach-agent $node4 $null
$ns connect $udp $null
$udp set fid_ 4

# #Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false




#Setup a TCP connection
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $node6 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $node7 $sink
$ns connect $tcp $sink
$tcp set fid_ 3

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP






# data packet generation starting time
$ns at 1.0 "$cbr start"
$ns at 0.2 "$ftp start"

# data packet generation ending time
$ns at 5.0 "$cbr stop"
$ns at 4.0 "$ftp stop"


#Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"

# ending nam and the simulation 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"

#Stopping the scheduler
$ns at 10.01 "puts \"end simulation\" ; $ns halt"


#$ns at 10.01 "$ns halt"
proc stop {} {
	global namfile tracefile ns
	$ns flush-trace
	close $namfile
	close $tracefile
	#executing nam file
	exec nam sample1.nam &
}


#Starting scheduler
$ns run

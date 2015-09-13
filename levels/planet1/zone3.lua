local levelData = {
    name             = "fuzzies in need",
    timeBonusSeconds = 35,
    startLedge       = 5,

    backgroundOrder = {
        [bgrFront] = {3, 4, 1, 2},
        [bgrMid]   = {3, 9, 3, 9},
        [bgrBack]  = {3, 4, 1, 2},
        [bgrSky]   = {1, 2}
    },

    elements = {
        {object="ledge", type="start"},

        {object="ledge", x=345, y=-120, size="medium3", pointsPos=left},
            {object="friend", type="fuzzy", x=-30, y=-50, color="Orange", onLedge=true},
            {object="rings", color=aqua, pattern={ {400,-230}, {0,-75}, {75,0}, {0,75} }},
            {object="scenery", x=150, y=-150, type="fg-tree-6-yellow", size=1, flip="x"},             

        {object="ledge", x=450, y=-40},

        {object="ledge", x=250, y=140, size="medium2"},
            {object="rings", color=aqua, trajectory={x=30, y=-200, xforce=110, yforce=170, arc=65, num=3}},
            {object="scenery", x=300, y=-250, type="fg-tree-6-yellow", size=1},
        
        {object="ledge", x=400, y=-240, size="big2", pointsPos=left},
            {object="gear",  type=gearTrajectory, onLedge=true},
            {object="wall",  x=300, y=-1250, type="fg-wall-divider", physics={shapeOffset={bottom=-30}, bounce=1}},
            {object="spike", x=300, y=-10,   type="fg-spikes-float-1"},
            {object="friend", type="fuzzy", x=335, y=-310, color="Pink", kinetic="hang", direction=left},
            
        {object="ledge", x=500, y=0},
            {object="wall",    x=275, y=-200, type="fg-rock-1", physics={shape="circle", bounce=1}},
            {object="scenery", x=390, y=-275, type="fg-flowers-5-yellow", layer=2, size=0.7, rotation=15, flip="x"},

        {object="ledge", x=500, y=-50, size="medium4"},
            {object="rings", color=aqua, pattern={ {400,-300}, {40,-80,color=pink}, {40,80} }},
        
        {object="ledge", x=600, y=-100, type="finish"}
    },
}

return levelData
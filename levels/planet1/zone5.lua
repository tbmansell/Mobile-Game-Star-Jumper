local levelData = {
    name             = "first contact",
    ceiling          = -1500,
    timeBonusSeconds = 50,
    startAtNight     = true,
    startLedge       = 1,

    backgroundOrder = {
        [bgrFront] = {1, 2, 3, 4},
        [bgrMid]   = {5, 10, 5, 10},
        [bgrBack]  = {2, 3, 4, 1},
        [bgrSky]   = {1, 2}
    },

    elements = {
        {object="ledge", type="start"},
            {object="scenery", x=150, y=-285, type="fg-foilage-1-yellow", layer=2},
            {object="rings", color=aqua, pattern={ {900,-350}, {0,75}, {0,75} }},

        {object="ledge", x=360, y=100, size="medium"},
            {object="enemy", type="brain", x=320, y=-300, size=0.5, color="Purple",
                behaviour={mode=stateSleeping, awaken=0},
                movement={pattern=movePatternVertical, distance=200, speed=0.3, pause=2000, moveStyle=moveStyleSway, pauseStyle=moveStyleSwaySmall}
            },
        
        {object="ledge", x=360, y=-175, size="medium2"},

        {object="ledge", x=-300, y=-300, size="medium"},
            {object="scenery", x=-50, y=-97, type="fg-foilage-3-yellow", layer=2, onLedge=true},
            {object="rings", color=aqua, trajectory={x=110, y=-150, xforce=180, yforce=75, arc=50, num=3}},

        {object="ledge", x=500, y=-85, size="big2"},
            {object="rings", color=aqua, pattern={ {370,-330} }},
            {object="scenery", x=50,  y=30,  type="fg-wall-double-l1", layer=2},
            {object="spike",   x=150, y=-180, type="fg-spikes-float-1", size=0.8, physics={shape={0,-110, 80,110, -80,110}} },
            {object="spike",   x=315, y=-180, type="fg-spikes-float-1", size=0.8, physics={shape={0,-110, 80,110, -80,110}}, flip="x"},

        {object="ledge", x=400, y=0, size="big2", flip="x"},

        {object="ledge", x=300, y=-100, size="medium"},
            {object="scenery", x=10, y=-97, type="fg-foilage-3-yellow", flip="x", layer=2},

            {object="enemy", type="brain", x=150, y=-150, size=0.5, color="Purple", spineDelay=700,
                behaviour={mode=stateSleeping, awaken=2},
                movement={pattern={{0,220}, {-400,0}, {0,-220}, {400,0}}, speed=2, moveStyle=moveStyleSway }
            },


        {object="ledge", x=200, y=-280, size="big3", flip="x"},
            {object="rings", color=aqua, trajectory={x=0, y=-280, xforce=180, yforce=15, arc=50, num=3}},
            {object="gear", x=70, y=-50, type=gearSpringShoes},
            
            {object="enemy", type="brain", x=200, y=-150, size=0.5, color="Purple",
                movement={pattern=movePatternVertical, distance=2, speed=0.3, pause=5000, moveStyle=moveStyleSwaySmall, pauseStyle=moveStyleSwayBig}
            },
            
        -- only easily reached with sping shoes
        {object="ledge", x=450, y=0, size="big3", ai={ignore=true}},
            {object="friend", type="fuzzy", x=0, y=-100, size=0.2, color="Orange", kinetic="bounce"},
            {object="scenery", x=-100, y=-200, type="fg-foilage-2-yellow", layer=2},

        -- remaining ledges alternatives to not using spring shoes
        {object="ledge", x=-800, y=-260, size="medium"},

        {object="ledge", x=350, y=-250, size="small"},

        {object="ledge", x=350, y=-50, size="small"},
            {object="spike", x=-1000, y=-500, type="fg-spikes-float-1", flip="y", size=0.8, physics={shape={-80,-110, 80,-110, 0,110}} },
            {object="spike", x=-835, y=-500, type="fg-spikes-float-1", flip="y", size=0.8, physics={shape={-80,-110, 80,-110, 0,110}} },

            {object="spike", x=50,  y=-500, type="fg-spikes-float-1", flip="y", size=0.8, physics={shape={-80,-110, 80,-110, 0,110}} },
            {object="spike", x=215, y=-500, type="fg-spikes-float-1", flip="y", size=0.8, physics={shape={-80,-110, 80,-110, 0,110}} },

            {object="spike", x=550,  y=-500, type="fg-spikes-float-1", flip="y", size=0.8, physics={shape={-80,-110, 80,-110, 0,110}} },
            {object="spike", x=715, y=-500, type="fg-spikes-float-1", flip="y", size=0.8, physics={shape={-80,-110, 80,-110, 0,110}} },


        {object="ledge", x=400, y=300, type="finish"}
    },
}

return levelData
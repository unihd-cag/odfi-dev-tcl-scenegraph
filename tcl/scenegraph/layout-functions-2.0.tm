package provide odfi::scenegraph::layouts 2.0.0
package require odfi::scenegraph 2.0.0

## Make a Row
#####################
odfi::scenegraph::newLayout "dummy" {
    
    
}

odfi::scenegraph::newLayout2 "dummy_row" {
    
    puts "Dummy row"
    ## Get constraints
    ########
    set spacing      [${constraints} getFloat spacing]
    set x            [${constraints} getFloat x 0]
    set y            [${constraints} getFloat y 0]
    set targetWidth  [${constraints} getInt "target-width"]
    
    ## FIXME
    set expandHeight [${constraints} getTrueFalse expand-height false]
    
    ## TBD
    set alignHeight [${constraints} getTrueFalse align-height false]
    

    set x -1
    set y -1
    set z -1
    set spacing 0
    
    ## Target Width is given, just adjust spacing
    
    #puts "Row with target width: $targetWidth"
    
    
    
    ## Layout the group in a row
    ###########
    
    ## Apply X-Y constraint
    set first [${group} member 0]
    if {$x>=0} {
        $first setX $x
    }
    if {$y>=0} {
        $first setY $y
    }
    
    #puts "First in group is now at: [$first getX]:[$first getY]"
    
    ## Height expansion
    ##########
    set tallest [$first getHeight]
    
    ## Foreach and Put in a row
    ##########
    #set i 1
    ${group} eachFrom 1 {
        
        ## X: Previous X + Previous Width + Spacing constraint
        set previous [${group} member [expr $i-1]]
        set newx [expr [$previous getX]+[$previous getWidth]+$spacing]
        
        
        #puts "Rowed in an element $i with $spacing to previous"
        #puts "Putting $elt at: $newx based on px: [$previous getX], pw: [$previous getWidth]"
        
        $elt setX $newx
        
        ## Align all Y
        $elt setY [$first getY]
        
        ## Tallest ?
        if {[$elt getHeight]>$tallest} {
            set tallest [$elt getHeight]
        }
        
        
    }
    
    return
    
    # Adjust for target Width
    ###########
    if {[${group} size] > 1 && $resultingWidth < $targetWidth} {
        
        set last [${group} member end]
        set resultingWidth [expr [$last getX]+[$last getWidth]]        
        set remaining [expr $targetWidth-$resultingWidth]
        set spacingPerInstance [expr $remaining/([${group} size]-1)]
        
        
        puts "Adjusting for target width, extra $remaining, so $spacingPerInstance each"
        
        ${group} relayout [list spacing $spacingPerInstance]
        
        
        #${group} eachFrom 1 {
            #    $elt setX [expr [$elt getX]+$spacingPerInstance]
            #}
    }
    
    ## Adjust for Expand Height ?
    if {$expandHeight==true} {
        ${group} each {
            
            if {[::odfi::common::isClass $it ::odfi::scenegraph::Group] && ([$elt getHeight] < $tallest)} {
                
                puts "Adjusting Height to tallest $tallest, actual [$elt getHeight]"
                $it relayout [list target-height $tallest]
            }
        }
    }      
    
}


odfi::scenegraph::newLayout2 "row" {

    ## Get constraints
    ########
    set spacing      [${constraints} getFloat spacing]
    set x            [${constraints} getFloat x 0]
    set y            [${constraints} getFloat y 0]
    set targetWidth  [${constraints} getInt "target-width"]

    ## FIXME
    set expandHeight [${constraints} getTrueFalse expand-height false]

    ## TBD
    set alignHeight [${constraints} getTrueFalse align-height false]


    ## Target Width is given, just adjust spacing

    #puts "Row with target width: $targetWidth"



    ## Layout the group in a row
    ###########

    ## Apply X-Y constraint
    set first [${group} member 0]
    if {$x>=0} {
        $first setX $x
    }
    if {$y>=0} {
        $first setY $y
    }

    #puts "First in group is now at: [$first getX]:[$first getY]"

    ## Height expansion
    ##########
    set tallest [$first getHeight]

    ## Foreach and Put in a row
    ##########
    #set i 1
    ${group} eachFrom 1 {

        ## X: Previous X + Previous Width + Spacing constraint
        set previous [${group} member [expr $i-1]]
        set newx [expr [$previous getX]+[$previous getWidth]+$spacing]
        
        
        puts "Rowed in an element $i with [${constraints} getInt spacing] to previous"
        #puts "Putting $elt at: $newx based on px: [$previous getX], pw: [$previous getWidth]"

        $elt setX $newx

        ## Align all Y
        $elt setY [$first getY]

        ## Tallest ?
        if {[$elt getHeight]>$tallest} {
            set tallest [$elt getHeight]
        }


    }

    # Adjust for target Width
    ###########
    set last [${group} member end]
    set resultingWidth [expr [$last getX]+[$last getWidth]]
    if {[${group} size] > 1 && $resultingWidth < $targetWidth} {

        set remaining [expr $targetWidth-$resultingWidth]
        set spacingPerInstance [expr $remaining/([${group} size]-1)]


        puts "Adjusting for target width, extra $remaining, so $spacingPerInstance each"

        ${group} relayout [list spacing $spacingPerInstance]


        #${group} eachFrom 1 {
        #    $elt setX [expr [$elt getX]+$spacingPerInstance]
        #}
    }

    ## Adjust for Expand Height ?
    if {$expandHeight==true} {
        ${group} each {

            if {[::odfi::common::isClass $it ::odfi::scenegraph::Group] && ([$elt getHeight] < $tallest)} {

                    puts "Adjusting Height to tallest $tallest, actual [$elt getHeight]"
                    $it relayout [list target-height $tallest]
            }
        }
    }


}


## \brief Like a 2D Column but in 3D
odfi::scenegraph::newLayout2 "column" {

     ## Get constraints
    ########
    set spacing         [${constraints} getFloat spacing]
    set x               [${constraints} getFloat x false]
    set y               [${constraints} getFloat y false]
    set z               [${constraints} getFloat z false]
    set targetHeight    [${constraints} getInt "target-height"]
    set alignWidth      [${constraints} getTrueFalse align-width false]
    set alignDepth     [${constraints} getTrueFalse align-depth false]

    ## Target Width is given, just adjust spacing

    ## Layout the group in a 3D Column
    ###########

    ## Apply X-Y-Z constraint
    set first [${group} member 0]
    if {$x != false } {
        $first setX $x
    }
    if {$y != false} {
        $first setY $y
    }
    if {$z != false} {
        $first setZ $z
    }


    ## Foreach and Put in a column
    ##########

    puts "Columning group size: [${group} size]"
    ${group} eachFrom 1 {

        ## Y: Previous Y + Previous Height + Spacing constraint
        set previous [${group} member [expr $i-1]]
        set newy [expr [$previous getY]+[$previous getHeight]+$spacing]

        #puts "Stacking, previous depth is: [$previous getDepth]"
        #puts "Rowed in an element with [$constraints getInt spacing] to previous"

        $elt setY $newy

        ## Align all X/Y
        if {$x != false } {
            $elt setX [$first getX]
        }
        if {$z != false} {
            $elt setZ [$first getZ]
        }
        
       

       # incr i

    }

    # Adjust for target Height
    ###########
    set last [${group} member end]
    set resultingHeight [expr [$last getY]+[$last getHeight]]
    if {[${group} size] > 1 && $resultingHeight < $targetHeight} {

        set remaining [expr $targetHeight-$resultingHeight]
        set spacingPerInstance [expr $remaining/([${group} size]-1)]
        #puts "** Adjusting for target depth $targetDepth, extra $remaining, so $spacingPerInstance each"


        ${group} relayout [list spacing $spacingPerInstance]

    }

    ## Align width 
    #########
    if {$alignWidth} {

        ## Get width of group 
        set groupWidth [${group} getWidth]

        ## Add left offset to all elements being smaller
        ${group} each {

            set remainingSpace [expr $groupWidth - [$it getWidth]]
            if {$remainingSpace>0} {
                $elt right [expr $remainingSpace/2]
            }
        }

    }

    ## Align Depth 
    ########################
    if {$alignDepth} {

        ## Get width of group 
        set groupDepth [${group} getDepth]

        ## Add bottom offset to all elements being smaller
        ${group} each {

            set remainingSpace [expr $groupDepth - [$it getDepth]]
            if {$remainingSpace>0} {
                $elt higher [expr $remainingSpace/2]
            }
        }

    }



}


## \brief Like a 2D Column but in 3D
odfi::scenegraph::newLayout2 "stack" {

     ## Get constraints
    ########
    set spacing     [${constraints} getFloat spacing]
    set x           [${constraints} getFloat x false]
    set y           [${constraints} getFloat y false]
    set z          [${constraints} getFloat z false]
    set targetDepth [${constraints} getInt "target-depth"]
    set alignWidth [${constraints} getTrueFalse align-width false]
    set alignHeight [${constraints} getTrueFalse align-height false]

    ## Target Width is given, just adjust spacing

    ## Layout the group in a 3D Column
    ###########

    ## Apply X-Y-Z constraint
    set first [${group} member 0]
    if {$x != false } {
        $first setX $x
    }
    if {$y != false} {
        $first setY $y
    }
    if {$z != false} {
        $first setZ $z
    }


    ## Foreach and Put in a column
    ##########
 
    puts "Stacking group size: [${group} size]"
    ${group} eachFrom 1 {

        ## Z: Previous Z + Previous Depth + Spacing constraint
        set previous [${group} member [expr $i-1]]
        set newz [expr [$previous getZ]+[$previous getDepth]+$spacing]

        puts "Stacking, previous depth is: [$previous getDepth]"
        #puts "Rowed in an element with [$constraints getInt spacing] to previous"

        $elt setZ $newz

        ## Align all X/Y
        if {$x != false } {
            $elt setX [$first getX]
        }
        if {$y != false} {
            $elt setY [$first getY]
        }
        
 

    }

    # Adjust for target Depth
    ###########
    set last [${group} member end]
    set resultingDepth [expr [$last getZ]+[$last getDepth]]
    if {[${group} size] > 1 && $resultingDepth < $targetDepth} {

        set remaining [expr $targetDepth-$resultingDepth]
        set spacingPerInstance [expr $remaining/([${group} size]-1)]
        #puts "** Adjusting for target depth $targetDepth, extra $remaining, so $spacingPerInstance each"


        ${group} relayout [list spacing $spacingPerInstance]

    }

    ## Align width 
    #########
    if {$alignWidth} {

        ## Get width of group 
        set groupWidth [${group} getWidth]

        ## Add left offset to all elements being smaller
        ${group} each {

            set remainingSpace [expr $groupWidth - [$it getWidth]]
            if {$remainingSpace>0} {
                $elt right [expr $remainingSpace/2]
            }
        }

    }

    ## Align Height 
    ########################
    if {$alignHeight} {

        ## Get width of group 
        set groupHeight [${group} getHeight]

        ## Add bottom offset to all elements being smaller
        ${group} each {

            set remainingSpace [expr $groupHeight - [$it getHeight]]
            if {$remainingSpace>0} {
                $elt up [expr $remainingSpace/2]
            }
        }

    }



}


## sect: mirrorZ
## The mirror Z is a recursive mirroring function.
## It will
##  - Reverse Z position of elements in any group
##  - For All objects, set the mirrored orientation on Y axis of actual one
## eof-sect: mirrorZ
##########################
odfi::scenegraph::newLayout2 "mirrorZ" {



    #puts "Mirroring group ${group} on X, with basic width: ${group}Width"

    ## Reverse on group
    ##################
    ${group} layout "reverseZ"

    ## reverse on all sub elements
    ################
    ${group} eachRecursive {

        #puts "Recursive meets $it"

        ## Group -> Reverse
        ###########
        if {[::odfi::common::isClass $it ::odfi::scenegraph::Group]} {

            #$it mirrorY
            $it layout "reverseZ"

        } else {

            ## Not a group -> mirrorY
            ## Mirror along Y means that the X coordinates will be "mirrored"
            #$it mirrorY

           # puts "---> changing orientation Recursive meets $it"
        }

    }

    #puts "---------"
    #puts "Mirroring group ${group} on X, Now width is: [${group} getR0Width]"


}

## \brief This reverses all the Z positions of the elements of the group.
## It is not a mirror as it stops to the members of the group, and does not recurse
odfi::scenegraph::newLayout2 "reverseZ" {



    ## Get basic group informations
    set groupHeight [${group} getDepth]


    ## For each member:
    ##########
    ${group} each {


        set oldZ [$elt getZ]
        set newZ [expr $groupHeight-($oldZ+[$elt getDepth])]



        ## New X position is the width of the group, minus the actual (x+width)
        $elt setZ $newZ


        #puts "----------- Moving element from $oldX:[$elt getWidth] to [$elt getX](calculated: $newX)"

    }

}

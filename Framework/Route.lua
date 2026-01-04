require("Framework/Common")

local VDqueuedOrders = {}
local VDplacedOrders = {}
local VDfailedOrders = {}
local routes = {}

local function placeVDorders(signals, orderType, orderTimes)
    if (#signals < 2) then
        Debug("Error: Not enough signals " .. #signals)
        return
    end

    for index, signal in ipairs(signals)
    do
        if (signals[index + 1] ~= nil) then
            Debug("Place route " .. signal .. " -> " .. signals[index + 1])
            local orderId = VDSetRoute(signal, signals[index + 1], orderType)
            table.insert(VDplacedOrders, { orderId = orderId, from = signal, to = signals[index + 1], orderType = orderType, orderTimes = orderTimes })
        end
    end
end

function HandleVDorderFailure(orderId)
    for index, order in ipairs(VDplacedOrders)
    do
        if (order.orderId == orderId) then
            Debug("route " .. order.from .. " -> " .. order.to .. " failed.")
            table.insert(VDfailedOrders, { from = order.from, to = order.to, orderType = order.orderType, orderTimes = order.orderTimes})
            table.remove(VDplacedOrders, index)
            break
        end
    end
end

function HandleVDorderAccepted(orderId)
    for index, order in ipairs(VDplacedOrders)
    do
        if (order.orderId == orderId) then
            Debug("Order " .. orderId .. " accepted")
            table.remove(VDplacedOrders, index)
            break
        end
    end
end


function ResubmitFailedVDorder()
    if (#VDfailedOrders > 0) then
        local maxOrderTimes = 10
        local order = VDfailedOrders[1]

        order.orderTimes = order.orderTimes or 0
        order.orderTimes = order.orderTimes + 1

        if (order.orderTimes > maxOrderTimes) then
            Debug("REMOVING FAILED ORDER due to max retries reached")
            table.remove(VDfailedOrders, 1)
            return false
        end

        placeVDorders({ order.from, order.to }, order.orderType, order.orderTimes)
        table.remove(VDfailedOrders, 1)
        return true
    end
    return false
end

function QueueVDorder(route, orderType, orderTimes)
    local orderId = os.time() .. math.random(1, 1000)
    table.insert(VDqueuedOrders, { routes = route, orderType = orderType, orderId = orderId, orderTimes = orderTimes} )
end


function ExecuteQueuedVDorder()
    if (#VDqueuedOrders > 0) then
        local order = VDqueuedOrders[1]
        Debug("Placing queued orderId " .. order.orderId)
        placeVDorders(order.routes, order.orderType, order.orderTimes)
        table.remove(VDqueuedOrders, 1)
    end
end

function SetRoute(scenarioState, _, _)
    local route = routes[scenarioState]
    if (route == nil) then
        Debug("ERROR: No route found for scenario state '" .. scenarioState .. "'")
        return
    end

    QueueVDorder(route.route, route.orderType)
end

function InitRoutes(routeConfig)
    routes = routeConfig
end
import importTemplate from "../../utils/importTemplate.js";
import inlinesvg from "../../utils/inlinesvg.js";

export default {
    data() {
        return {
            patrolSpeed: 0,
            frontRadarSpeed: 0,
            frontRadarPlate: "",
            rearRadarSpeed: 0,
            rearRadarPlate: "",
            location: {
                street: "undefined",
                heading: "N"
            },
            fwdMode: 'same',
            bwdMode: 'same',
            frontSpeedWarning: false,
            rearSpeedWarning: false,
            frontAllowRadarSpeed: "",
            frontLockedSpeed: false,
            rearLockedSpeed: false,
            lockedFrontVehicle: false,
            lockedRearVehicle: false,
            showFastActions: false,
            radarPower: true,
            keys: [],
            frontXMIT : true,
            rearXMIT : true,

        };
    },
    components: {
        inlinesvg
    },
    computed: {
        ...Vuex.mapState({
            Locales : state => state.Locales,
        })
    },
    methods: {
        PlaySound() {
            let audio = new Audio(`./assets/btn.ogg`);
            audio.play();
            audio.volume = 0.2;
        },
        setShowFastActions(payload) {
            this.showFastActions = payload
        },
        radarAction(type, payload) {
            postNUI("radarAction", {
                type,
                payload
            });
        },
        messageHandler(event) {
            switch (event.data.action) {
                case "SET_FRONT_RADAR_SPEED":
                    this.frontRadarSpeed = event.data.payload.toFixed(0);
                    break;
                case "ADD_KEY":
                    this.keys.push(event.data.payload)
                    break
                case "CLEAR_KEYS":
                    this.keys = []
                    break
                case "TOGGLE_FAST_ACTIONS":
                    this.setShowFastActions(event.data.payload)
                    break
                case "SET_PATROL_SPEED":
                    this.patrolSpeed = event.data.payload.toFixed(0);
                    break;
                case "SET_FRONT_RADAR_PLATE":
                    this.frontRadarPlate = event.data.payload;
                    break;
                case "SET_REAR_RADAR_PLATE":
                    this.rearRadarPlate = event.data.payload;
                    break;
                case "SET_REAR_RADAR_SPEED":
                    this.rearRadarSpeed = event.data.payload.toFixed(0);
                    break;
                case "SET_LOCATION":
                    this.location.street = event.data.payload.street;
                    this.location.heading = event.data.payload.heading;
                    break;
            
                case "FORCE_UPDATE":
                    this.fwdMode = event.data.payload.fwdMode
                    this.bwdMode = event.data.payload.bwdMode
                    this.frontSpeedWarning = event.data.payload.frontSpeedWarning
                    this.rearSpeedWarning = event.data.payload.rearSpeedWarning
                    this.frontLockedSpeed = event.data.payload.frontLockedSpeed
                    this.rearLockedSpeed = event.data.payload.rearLockedSpeed
                    this.lockedFrontVehicle = event.data.payload.lockedFrontVehicle
                    this.lockedRearVehicle = event.data.payload.lockedRearVehicle
                    this.radarPower = event.data.payload.radarPower
                    this.frontXMIT = event.data.payload.frontXMIT
                    this.rearXMIT =  event.data.payload.rearXMIT
                    break

                default:
                    break;
            }
        },
        FormatSpeed(speed) {
            if (!speed) {
                speed = 0
            }
            if (!isNaN(speed)) {
                speed = speed.toString()
            }
            if (speed.length == 1) {
                if (speed == 10) {
                }
                return `00<span>${speed[0]}</span>`;
            }
            if (speed.length == 2) {
                if (speed == 10) {
                }
                return `0<span>${speed[0]}</span><span>${speed[1]}</span>`;
            }
            if (speed.length == 3) {
                if (speed == 10) {
                }
                return `<span>${speed[0]}</span><span>${speed[1]}</span><span>${speed[2]}</span>`;
            }

            return "000";
        },
        updateFromRadarSpeedValue(val) {
            if (val > 0 && val <= 300) {
                this.frontAllowRadarSpeed = val;
            } else {
                this.frontAllowRadarSpeed = "";
            }
        }
    },
    mounted() {
        window.addEventListener("message", this.messageHandler);
    },
    beforeDestroy() {
        window.removeEventListener("message", this.messageHandler);
    },
    watch: {
        frontRadarSpeedValue(val) {
            if (val > 0 && val <= 300) {
                this.frontAllowRadarSpeed = val;
            }
        }
    },
    template: await importTemplate("./app/pages/radar/index.html")
};

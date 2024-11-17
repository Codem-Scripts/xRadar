import importTemplate from '../../../../utils/importTemplate.js'
import inlinesvg from '../../../../utils/inlinesvg.js'

export default {
    data() {
        return {
            fwdMode: 'same',
            bwdMode: 'same',
            frontXMIT : true,
            rearXMIT : true,
        }
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
        messageHandler(event) {
            switch (event.data.action) {
                case "FORCE_UPDATE":
                    this.fwdMode = event.data.payload.fwdMode
                    this.bwdMode = event.data.payload.bwdMode

                    this.frontXMIT = event.data.payload.frontXMIT
                    this.rearXMIT =  event.data.payload.rearXMIT
                    break
           
                default:
                    break;
            }
        },
        PlaySound() {
            let audio = new Audio(`./assets/btn.ogg`);
            audio.play();
            audio.volume = 0.2;
        },
        setFrontXMIT(){
            postNUI('radarAction', {
                type: 'setFrontXMIT'
            })
        },
        setRearXMIT(){
            postNUI('radarAction', {
                type: 'setRearXMIT'
            })
        },
        setFWDMode(payload) {
            postNUI('radarAction', {
                payload,
                type: 'setFWDMode'
            })
        },
        setBWDMode(payload) {
            postNUI('radarAction', {
                payload,
                type: 'setBWDMode'
            })
        },

    },
    mounted() {
        window.addEventListener("message", this.messageHandler);
    },
    beforeDestroy() {
        window.removeEventListener("message", this.messageHandler);
    },
    props: ['setActivePage'],
    template: await importTemplate('./app/pages/tablet/components/settings/index.html')
}

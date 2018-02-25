import $ from 'jquery';
import config from '../config';
import UserActivityLogger from '../UserActivityLogger';
import ZeeguuRequests from '../zeeguuRequests';
import {POST_UNSTAR_ARTICLE} from '../zeeguuRequests';
import {POST_STAR_ARTICLE} from '../zeeguuRequests';


const USER_EVENT_STAR_ARTICLE = 'STAR ARTICLE';
const USER_EVENT_UNSTAR_ARTICLE = 'UNSTAR ARTICLE';
const OFF = 'off';

const HTML_ID_TOGGLESTAR = '#toggle_star';

/**
 * Implements the functionality for starring an article, together with 
 * notifying Zeeguu about the changes.
 */
export default class Starer {
    /**
     * Initializes the state of the starer (default is false).
     */
    constructor(state=false) {
        this.on = state; 
    }

    /**
     * Sets the state of the starer.
     * @param {boolean} state - Defines the state for the starer: true - 'on' or false - 'off' 
     */
    setState(state) {
        this.on = state;
    }

    /**
     * Toggles the star on/off based on its current state and notifies
     * Zeeguu accordingly.
     */
    toggle() {
        let url = $(config.HTML_ID_ARTICLE_URL).children('a').attr('href');
        let title = $(config.HTML_ID_ARTICLE_TITLE).text();

        if (this.on) {
            // Launch Zeeguu request to notify about unstarring of article by user.
            ZeeguuRequests.post(POST_UNSTAR_ARTICLE, {url: url});
            UserActivityLogger.log(USER_EVENT_UNSTAR_ARTICLE, url);
    
        } else { // it's off            
            // Launch Zeeguu request to notify about starring an article.
            ZeeguuRequests.post(POST_STAR_ARTICLE, {url: url});
            UserActivityLogger.log(USER_EVENT_STAR_ARTICLE, url);
        }
        this._toggleState();
        this._toggleIcon();
    }

    /**
     * Toggles the internal state of this class between true and false.
     */
    _toggleState() {
        this.on = (this.on ? false : true);
    }

    /**
     * Toggles the icon of the star by adding or removing a class representing OFF.
     */
    _toggleIcon() {
        $(HTML_ID_TOGGLESTAR).children().each(function() {
            $(this).toggleClass(OFF);
        });
    }
}
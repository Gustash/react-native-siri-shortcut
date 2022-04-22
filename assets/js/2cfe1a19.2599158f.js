"use strict";(self.webpackChunkreact_native_siri_shortcut_docs=self.webpackChunkreact_native_siri_shortcut_docs||[]).push([[247],{3905:function(t,e,n){n.d(e,{Zo:function(){return d},kt:function(){return h}});var i=n(7294);function r(t,e,n){return e in t?Object.defineProperty(t,e,{value:n,enumerable:!0,configurable:!0,writable:!0}):t[e]=n,t}function o(t,e){var n=Object.keys(t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(t);e&&(i=i.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),n.push.apply(n,i)}return n}function a(t){for(var e=1;e<arguments.length;e++){var n=null!=arguments[e]?arguments[e]:{};e%2?o(Object(n),!0).forEach((function(e){r(t,e,n[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(n,e))}))}return t}function s(t,e){if(null==t)return{};var n,i,r=function(t,e){if(null==t)return{};var n,i,r={},o=Object.keys(t);for(i=0;i<o.length;i++)n=o[i],e.indexOf(n)>=0||(r[n]=t[n]);return r}(t,e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(t);for(i=0;i<o.length;i++)n=o[i],e.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(t,n)&&(r[n]=t[n])}return r}var c=i.createContext({}),u=function(t){var e=i.useContext(c),n=e;return t&&(n="function"==typeof t?t(e):a(a({},e),t)),n},d=function(t){var e=u(t.components);return i.createElement(c.Provider,{value:e},t.children)},l={inlineCode:"code",wrapper:function(t){var e=t.children;return i.createElement(i.Fragment,{},e)}},p=i.forwardRef((function(t,e){var n=t.components,r=t.mdxType,o=t.originalType,c=t.parentName,d=s(t,["components","mdxType","originalType","parentName"]),p=u(n),h=r,m=p["".concat(c,".").concat(h)]||p[h]||l[h]||o;return n?i.createElement(m,a(a({ref:e},d),{},{components:n})):i.createElement(m,a({ref:e},d))}));function h(t,e){var n=arguments,r=e&&e.mdxType;if("string"==typeof t||r){var o=n.length,a=new Array(o);a[0]=p;var s={};for(var c in e)hasOwnProperty.call(e,c)&&(s[c]=e[c]);s.originalType=t,s.mdxType="string"==typeof t?t:r,a[1]=s;for(var u=2;u<o;u++)a[u]=n[u];return i.createElement.apply(null,a)}return i.createElement.apply(null,n)}p.displayName="MDXCreateElement"},8714:function(t,e,n){n.r(e),n.d(e,{assets:function(){return l},contentTitle:function(){return u},default:function(){return m},frontMatter:function(){return c},metadata:function(){return d},toc:function(){return p}});var i=n(7462),r=n(3366),o=(n(7294),n(3905)),a=n(8825),s=["components"],c={},u="Donating Shortcuts",d={unversionedId:"api/donating-shortcuts",id:"api/donating-shortcuts",title:"Donating Shortcuts",description:"Donate shortcut for an activity each time the user does it. For example, each time the user orders soup you may want to donate an activity that is relevant to ordering soup. Siri will use this information to then potentially recommend this activity to the user in their spotlight etc.",source:"@site/docs/api/donating-shortcuts.mdx",sourceDirName:"api",slug:"/api/donating-shortcuts",permalink:"/react-native-siri-shortcut/docs/api/donating-shortcuts",editUrl:"https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/docs/api/donating-shortcuts.mdx",tags:[],version:"current",frontMatter:{},sidebar:"sidebar",previous:{title:"Clearing Shortcuts",permalink:"/react-native-siri-shortcut/docs/api/clearing-shortcuts"},next:{title:"List Recorded Shortcuts",permalink:"/react-native-siri-shortcut/docs/api/list-recorded-shortcuts"}},l={},p=[{value:"API Definition",id:"api-definition",level:2},{value:"<code>donateShortcut</code>",id:"donateshortcut",level:3},{value:"Type Reference",id:"type-reference",level:2},{value:"<code>ShortcutOptions</code>",id:"shortcutoptions",level:3}],h={toc:p};function m(t){var e=t.components,n=(0,r.Z)(t,s);return(0,o.kt)("wrapper",(0,i.Z)({},h,n,{components:e,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"donating-shortcuts"},"Donating Shortcuts"),(0,o.kt)("p",null,"Donate shortcut for an activity each time the user does it. For example, each time the user orders soup you may want to donate an activity that is relevant to ordering soup. Siri will use this information to then potentially recommend this activity to the user in their spotlight etc."),(0,o.kt)("div",{className:"admonition admonition-note alert alert--secondary"},(0,o.kt)("div",{parentName:"div",className:"admonition-heading"},(0,o.kt)("h5",{parentName:"div"},(0,o.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,o.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,o.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.3 5.69a.942.942 0 0 1-.28-.7c0-.28.09-.52.28-.7.19-.18.42-.28.7-.28.28 0 .52.09.7.28.18.19.28.42.28.7 0 .28-.09.52-.28.7a1 1 0 0 1-.7.3c-.28 0-.52-.11-.7-.3zM8 7.99c-.02-.25-.11-.48-.31-.69-.2-.19-.42-.3-.69-.31H6c-.27.02-.48.13-.69.31-.2.2-.3.44-.31.69h1v3c.02.27.11.5.31.69.2.2.42.31.69.31h1c.27 0 .48-.11.69-.31.2-.19.3-.42.31-.69H8V7.98v.01zM7 2.3c-3.14 0-5.7 2.54-5.7 5.68 0 3.14 2.56 5.7 5.7 5.7s5.7-2.55 5.7-5.7c0-3.15-2.56-5.69-5.7-5.69v.01zM7 .98c3.86 0 7 3.14 7 7s-3.14 7-7 7-7-3.12-7-7 3.14-7 7-7z"}))),"note")),(0,o.kt)("div",{parentName:"div",className:"admonition-content"},(0,o.kt)("p",{parentName:"div"},"These recommendations are based on factors such as time and location."))),(0,o.kt)("div",{className:"admonition admonition-warning alert alert--danger"},(0,o.kt)("div",{parentName:"div",className:"admonition-heading"},(0,o.kt)("h5",{parentName:"div"},(0,o.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,o.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,o.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M5.05.31c.81 2.17.41 3.38-.52 4.31C3.55 5.67 1.98 6.45.9 7.98c-1.45 2.05-1.7 6.53 3.53 7.7-2.2-1.16-2.67-4.52-.3-6.61-.61 2.03.53 3.33 1.94 2.86 1.39-.47 2.3.53 2.27 1.67-.02.78-.31 1.44-1.13 1.81 3.42-.59 4.78-3.42 4.78-5.56 0-2.84-2.53-3.22-1.25-5.61-1.52.13-2.03 1.13-1.89 2.75.09 1.08-1.02 1.8-1.86 1.33-.67-.41-.66-1.19-.06-1.78C8.18 5.31 8.68 2.45 5.05.32L5.03.3l.02.01z"}))),"warning")),(0,o.kt)("div",{parentName:"div",className:"admonition-content"},(0,o.kt)("p",{parentName:"div"},"Do not donate an activity if the user hasn't done it."))),(0,o.kt)("h2",{id:"api-definition"},"API Definition"),(0,o.kt)("h3",{id:"donateshortcut"},(0,o.kt)("inlineCode",{parentName:"h3"},"donateShortcut")),(0,o.kt)("p",null,"Donate a shortcut for an activity that the user just did."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-typescript"},"donateShortcut(options: ShortcutOptions): void;\n")),(0,o.kt)("h2",{id:"type-reference"},"Type Reference"),(0,o.kt)("h3",{id:"shortcutoptions"},(0,o.kt)("inlineCode",{parentName:"h3"},"ShortcutOptions")),(0,o.kt)(a.ZP,{mdxType:"ShortcutOptions"}))}m.isMDXComponent=!0},8825:function(t,e,n){n.d(e,{ZP:function(){return c}});var i=n(7462),r=n(3366),o=(n(7294),n(3905)),a=["components"],s={toc:[]};function c(t){var e=t.components,n=(0,r.Z)(t,a);return(0,o.kt)("wrapper",(0,i.Z)({},s,n,{components:e,mdxType:"MDXLayout"}),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-typescript"},"{\n  /** The activity type with which the user activity object was created. */\n  activityType: string;\n  /** An optional, user-visible title for this activity, such as a document name or web page title. */\n  title?: string;\n  /** A set of keys that represent the minimal information about the activity that should be stored for later restoration. */\n  requiredUserInfoKeys?: Array<string>;\n  /** A dictionary containing app-specific state information needed to continue an activity on another device. */\n  userInfo?: { [key: string]: any };\n  /** Indicates that the state of the activity needs to be updated. */\n  needsSave?: boolean;\n  /** A set of localized keywords that can help users find the activity in search results. */\n  keywords?: Array<string>;\n  /** A value used to identify the user activity. */\n  persistentIdentifier?: string;\n  /** A Boolean value that indicates whether the activity can be continued on another device using Handoff. */\n  isEligibleForHandoff?: boolean;\n  /** A Boolean value that indicates whether the activity should be added to the on-device index. */\n  isEligibleForSearch?: boolean;\n  /** A Boolean value that indicates whether the activity can be publicly accessed by all iOS users. */\n  isEligibleForPublicIndexing?: boolean;\n  /** The date after which the activity is no longer eligible for Handoff or indexing. In ms since Unix Epox */\n  expirationDate?: number;\n  /** Webpage to load in a browser to continue the activity. */\n  webpageURL?: string;\n  /** A Boolean value that determines whether Siri can suggest the user activity as a shortcut to the user. */\n  isEligibleForPrediction?: boolean;\n  /** A phrase suggested to the user when they create a shortcut. */\n  suggestedInvocationPhrase?: string;\n  /** Content type of this shorcut. Check available options at https://developer.apple.com/documentation/mobilecoreservices/uttype/uti_abstract_types */\n  contentType?: string;\n  /** An optional description for the shortcut. */\n  description?: string;\n}\n")))}c.isMDXComponent=!0}}]);
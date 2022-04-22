// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: "React Native Siri Shortcut",
  tagline: "Use Siri Shortcuts in React Native",
  url: "https://gustash.github.io",
  baseUrl: "/react-native-siri-shortcut/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "img/favicon.ico",
  organizationName: "gustash", // Usually your GitHub org/user name.
  projectName: "react-native-siri-shortcut", // Usually your repo name.
  presets: [
    [
      "classic",
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: require.resolve("./sidebars.js"),
          // Please change this to your repo.
          editUrl:
            "https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/",
          remarkPlugins: [
            [require("@docusaurus/remark-plugin-npm2yarn"), { sync: true }],
          ],
        },
        pages: {
          remarkPlugins: [require("@docusaurus/remark-plugin-npm2yarn")],
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: "RN Siri Shortcut",
        logo: {
          alt: "Siri Logo",
          src: "img/icons8-siri.svg",
        },
        items: [
          {
            type: "doc",
            docId: "getting-started/installation",
            position: "left",
            label: "Getting Started",
          },
          {
            type: "doc",
            docId: "api/listening-for-shortcuts",
            position: "left",
            label: "Docs",
          },
          {
            href: "https://github.com/gustash/react-native-siri-shortcut",
            label: "GitHub",
            position: "right",
          },
        ],
      },
      footer: {
        style: "dark",
        links: [
          {
            title: "Docs",
            items: [
              {
                label: "Getting Started",
                to: "/docs",
              },
              {
                label: "API Reference",
                to: "/docs/api/listening-for-shortcuts",
              },
            ],
          },
          {
            title: "Mentions",
            items: [
              {
                label: "Shortcuts icon by Icons8",
                href: "https://icons8.com/icon/g0O6cMpaOTj0/shortcuts",
              },
              {
                label: "Siri icon by Icons8",
                href: "https://icons8.com/icon/kfEmwYAkH0Em/siri",
              },
              {
                label: "Open Source icon by Icons8",
                href: "https://icons8.com/icon/65836/open-source",
              },
            ],
          },
          {
            title: "More",
            items: [
              {
                label: "GitHub",
                href: "https://github.com/gustash/react-native-siri-shortcut",
              },
              {
                label: "Twitter",
                href: "https://twitter.com/TheGustash",
              },
            ],
          },
        ],
        copyright: `Built with Docusaurus.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
};

module.exports = config;

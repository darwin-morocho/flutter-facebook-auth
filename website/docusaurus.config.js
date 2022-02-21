// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require("prism-react-renderer/themes/github");
const darkCodeTheme = require("prism-react-renderer/themes/dracula");

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: "Flutter Facebook Auth",
  tagline:
    "The easiest way to add facebook login to your flutter app, get user information, profile picture and more. Web support included.",
  url: "https://facebook.meedu.app",
  baseUrl: "/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "img/favicon.ico",
  organizationName: "darwin-morocho", // Usually your GitHub org/user name.
  projectName: "flutter-facebook-auth", // Usually your repo name.

  presets: [
    [
      "@docusaurus/preset-classic",
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: require.resolve("./sidebars.js"),
          // Please change this to your repo.
          editUrl: "https://github.com/darwin-morocho/flutter-facebook-auth/tree/master/website",
          lastVersion: "current",
          versions: {
            current: {
              label: "4.1.1",
              path: "4.x.x",
            },
            "3.x.x": {
              label: "3.x.x",
              path: "3.x.x",
            },
          },
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
        title: "flutter_facebook_auth",

        items: [
          {
            type: "doc",
            docId: "intro",
            position: "left",
            label: "Tutorial",
          },
          {
            href: "https://github.com/darwin-morocho/flutter-facebook-auth",
            label: "GitHub",
            position: "right",
          },
          {
            type: 'docsVersionDropdown',
            position: 'left',
            dropdownActiveClassDisabled: true,
          },
        ],
      },
      footer: {
        style: "dark",
        copyright: `Copyright © ${new Date().getFullYear()} FLUTTER MEEDU. Built with Docusaurus.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
        additionalLanguages: ["powershell", "dart", "yaml"],
      },
    }),
};

module.exports = config;
